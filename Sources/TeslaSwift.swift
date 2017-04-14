//
//  TeslaSwift.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 04/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper
import PromiseKit
import SwiftWebSocket

public enum RoofState: String {
	case Open		= "open"
	case Close		= "close"
	case Comfort	= "comfort"
	case Vent		= "vent"
	case Move		= "move"
}

public enum VehicleCommand {
	case wakeUp
	case valetMode(valetActivated: Bool, pin: String?)
	case resetValetPin
	case openChargeDoor
	case chargeLimitStandard
	case chargeLimitMaxRange
	case chargeLimitPercentage(limit:Int)
	case startCharging
	case stopCharging
	case flashLights
	case honkHorn
	case unlockDoors
	case lockDoors
	case setTemperature(driverTemperature:Double, passengerTemperature:Double)
	case startAutoConditioning
	case stopAutoConditioning
	case setSunRoof(state:RoofState, percentage:Int)
	case startVehicle(password:String)
	case openTrunk(options:OpenTrunkOptions)
	
	func path() -> String {
		switch self {
		case .wakeUp:
			return "wake_up"
		case .valetMode:
			return "command/set_valet_mode"
		case .resetValetPin:
			return "command/reset_valet_pin"
		case .openChargeDoor:
			return "command/charge_port_door_open"
		case .chargeLimitStandard:
			return "command/charge_standard"
		case .chargeLimitMaxRange:
			return "command/charge_max_range"
		case .chargeLimitPercentage:
			return  "command/set_charge_limit"
		case .startCharging:
			return  "command/charge_start"
		case .stopCharging:
			return "command/charge_stop"
		case .flashLights:
			return "command/flash_lights"
		case .honkHorn:
			return "command/honk_horn"
		case .unlockDoors:
			return "command/door_unlock"
		case .lockDoors:
			return "command/door_lock"
		case .setTemperature:
			return "command/set_temps"
		case .startAutoConditioning:
			return "command/auto_conditioning_start"
		case .stopAutoConditioning:
			return "command/auto_conditioning_stop"
		case .setSunRoof:
			return "command/sun_roof_control"
		case .startVehicle:
			return "command/remote_start_drive"
		case .openTrunk:
			return "command/trunk_open"
		}
	}
}

public enum TeslaError: Error {
	case networkError(error:NSError)
	case authenticationRequired
	case authenticationFailed
	case invalidOptionsForCommand
	case failedToParseData
}

let ErrorInfo = "ErrorInfo"


open class TeslaSwift {
	
	open var useMockServer = false
	open var debuggingEnabled = false
	
	open var token: AuthToken?
	
    fileprivate var email: String? = UserDefaults.standard.object(forKey: "TeslaSwift,email") as? String
	fileprivate var password: String?
    fileprivate var webSocket: WebSocket?
	
	public init() { }
}

extension TeslaSwift {
	
	
	public var isAuthenticated: Bool {
		return token != nil
	}
	
	/**
	Performs the authentition with the Tesla API
	
	You only need to call this once. The token will be stored and your credentials.
	If the token expires your credentials will be reused.
	
	- parameter email:      The email address.
	- parameter password:   The password.
	
	- returns: A Promise with the AuthToken.
	*/

	public func authenticate(email: String, password: String) -> Promise<AuthToken> {
		
		self.email = email
        UserDefaults.standard.set(email, forKey: "TeslaSwift.email")
		self.password = password

		let body = AuthTokenRequest(email: email,
		                            password: password,
		                            grantType: "password",
		                            clientID: "e4a9949fcfa04068f59abb5a658f2bac0a3428e4652315490b659d5ab3f35a9e",
		                            clientSecret: "c75f14bbadc8bee3a7594412c31416f8300256d7668ea7e6e7f06727bfb9d220")
		
		return request(.authentication, body: body)
			.then(on: .global()) { (result: AuthToken) -> AuthToken in
				self.token = result
				return result
		}.recover { (error) -> AuthToken in

			if case let TeslaError.networkError(error: internalError) = error {
				if internalError.code == 401 {
					throw TeslaError.authenticationFailed
				} else {
					throw error
				}
			} else {
				throw error
			}
		}
	}
	
	
	/**
	Use this method to reuse a previous authentication token
	
	This method is useful if your app wants to ask the user for credentials once and reuse the token skiping authentication
	If the token is invalid a new authentication will be required
	
	*/
	public func reuse(token: AuthToken) {
		self.token = token
	}
	
	/**
	Removes all the information related to the previous authentication
	
	*/
	public func logout() {
		email = nil
		password = nil
		token = nil
	}
	
	/**
	Fetchs the list of your vehicles including not yet delivered ones
	
	- returns: A Promise with an array of Vehicles.
	*/
	public func getVehicles() -> Promise<[Vehicle]> {
		
		return checkAuthentication().then(on: .global()) { _ in
			self.request(.vehicles, body: nil)
			}.then(on: .global()) { (data: ArrayResponse<Vehicle>) -> [Vehicle] in
				data.response
		}
		
	}
	
	public func getAllData(_ vehicle: Vehicle) -> Promise<VehicleExtended> {
		return checkAuthentication().then(on: .global()) {
			(token) -> Promise<Response<VehicleExtended>> in
			
			let vehicleID = vehicle.id!
			
			return self.request(.allStates(vehicleID: vehicleID))
			
			}.then(on: .global()) {
				(data: Response<VehicleExtended>) -> VehicleExtended in
				
				data.response
		}
	}
	
	/**
	Fetchs the vehicle mobile access state
	
	- returns: A Promise with mobile access state.
	*/
	public func getVehicleMobileAccessState(_ vehicle: Vehicle) -> Promise<Bool> {
		
		return checkAuthentication().then(on: .global()) {
			(token) -> Promise<BoolResponse> in
			
			let vehicleID = vehicle.id!
			
			return self.request(.mobileAccess(vehicleID: vehicleID))
			
			}.then(on: .global()) {
				(data: BoolResponse) -> Bool in
				
				data.response
		}
	}
	
	/**
	Fetchs the vehicle charge state
	
	- returns: A Promise with charge state.
	*/
	public func getVehicleChargeState(_ vehicle: Vehicle) -> Promise<ChargeState> {
		
		
		return checkAuthentication().then(on: .global()) {
			(token) -> Promise<Response<ChargeState>> in
			
			let vehicleID = vehicle.id!
			
			return self.request(.chargeState(vehicleID: vehicleID))
			
			}.then(on: .global()) {
				(data: Response<ChargeState>) -> ChargeState in
				
				data.response
			}
	}
	
	/**
	Fetchs the vehicle Climate state
	
	- returns: A Promise with Climate state.
	*/
	public func getVehicleClimateState(_ vehicle: Vehicle) -> Promise<ClimateState> {
		
		return checkAuthentication().then(on: .global()) {
			(token) -> Promise<Response<ClimateState>> in
			
			let vehicleID = vehicle.id!
			
			return self.request(.climateState(vehicleID: vehicleID))
				
			}.then(on: .global()) {
				(data: Response<ClimateState>) -> ClimateState in
				
				data.response
			}
	}
	
	/**
	Fetchs the vehicledrive state
	
	- returns: A Promise with drive state.
	*/
	public func getVehicleDriveState(_ vehicle: Vehicle) -> Promise<DriveState> {
		
		return checkAuthentication().then(on: .global()) {
			(token) -> Promise<Response<DriveState>> in
			
			let vehicleID = vehicle.id!
			
			return self.request(.driveState(vehicleID: vehicleID))
				
			}.then(on: .global()) {
				(data: Response<DriveState>) -> DriveState in
				
					data.response
			}
	}
	
	/**
	Fetchs the vehicle Gui Settings
	
	- returns: A Promise with Gui Settings.
	*/
	public func getVehicleGuiSettings(_ vehicle: Vehicle) -> Promise<GuiSettings> {
		
		return checkAuthentication().then(on: .global()) {
			(token) -> Promise<Response<GuiSettings>> in
			
			let vehicleID = vehicle.id!
			
			return self.request(.guiSettings(vehicleID: vehicleID))
			
			}.then(on: .global()) {
				(data: Response<GuiSettings>) -> GuiSettings in
				
					data.response
			}
	}
	
	/**
	Fetchs the vehicle state
	
	- returns: A Promise with vehicle state.
	*/
	public func getVehicleState(_ vehicle: Vehicle) -> Promise<VehicleState> {
		
		return checkAuthentication().then(on: .global()) {
			(token) -> Promise<Response<VehicleState>> in
			
			let vehicleID = vehicle.id!
			
			return self.request(.vehicleState(vehicleID: vehicleID))
			
			}.then(on: .global()) {
				(data: Response<VehicleState>) -> VehicleState in
				
				data.response
		}
	}
	
	/**
	Sends a command to the vehicle
	
	- parameter vehicle: the vehicle that will receive the command
	- parameter command: the command to send to the vehicle
	- returns: A Promise with the CommandResponse object containing the results of the command.
	*/
	public func sendCommandToVehicle(_ vehicle: Vehicle, command: VehicleCommand) -> Promise<CommandResponse> {
		
		var body: Mappable?
		
		switch command {
		case let .valetMode(valetActivated, pin):
			body = ValetCommandOptions(valetActivated: valetActivated, pin: pin)
		case let .openTrunk(options):
			body = options
		case let .chargeLimitPercentage(limit):
			body = ChargeLimitPercentageCommandOptions(limit: limit)
		case let .setTemperature(driverTemperature, passengerTemperature):
			body = SetTemperatureCommandOptions(driverTemperature: driverTemperature, passengerTemperature: passengerTemperature)
		case let .setSunRoof(state, percent):
			body = SetSunRoofCommandOptions(state: state, percent: percent)
		case let .startVehicle(password):
			body = RemoteStartDriveCommandOptions(password: password)
		default: break
		}
		
		return checkAuthentication()
			.then(on: .global()) { (token) -> Promise<CommandResponse> in
			self.request(.command(vehicleID: vehicle.id!, command: command), body: body)
		}
		
	}
    
    // MARK: Streaming API
    
    static let streamingBaseURL: String = "wss://streaming.vn.teslamotors.com"
    static let streamParameters: [String] = ["speed", "odometer", "soc", "elevation", "est_heading", "est_lat", "est_lng", "power", "shift_state", "range", "est_range", "heading"]

    private func getStreamURLRequest(vehicle: Vehicle) -> URLRequest? {
        guard let vehicleID = vehicle.vehicleID else {
            return nil
        }
        let vehicleIDString: String = String(describing: vehicleID)
        let streamParametersString: String = TeslaSwift.streamParameters.joined(separator: ",")
        let urlString = "\(TeslaSwift.streamingBaseURL)/stream/\(vehicleIDString)/?values=\(streamParametersString)"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            if let token = self.token?.accessToken,
                let email = self.email {
                    let authString = String(format: "%@:%@", email, token)
                    let authData = authString.data(using: String.Encoding.utf8)!
                    let base64AuthString = authData.base64EncodedString()
                    request.httpMethod = "GET"
                    request.setValue(base64AuthString, forHTTPHeaderField: "Authorization")
                    return request
            }
        }
        return nil
    }
    
    /**
     Streams vehicle data using a websocket
     
     - parameter vehicle: the vehicle that will receive the command
     - parameter dataReceived: callback to receive the websocket data
     */
    public func openStream(vehicle: Vehicle, dataReceived: @escaping (StreamEvent) -> Void) {
        if let urlRequest: URLRequest = getStreamURLRequest(vehicle: vehicle) {
            webSocket = WebSocket(request: urlRequest)
            print("Open Websocket")
            webSocket?.open()
            webSocket?.event.message = { data in
                print("data: \(data)")
                if let string = data as? String,
                    let mapped: StreamEvent = Mapper<StreamEvent>().map(JSONString: string) {
                        dataReceived(mapped)
                }
            }
        }
    }
    
    public func closeStream() {
        webSocket?.close()
    }
}

extension TeslaSwift {
	
	func checkToken() -> Promise<Bool> {
		
		if let token = self.token {
			return Promise<Bool>(value: token.isValid)
		} else {
			return Promise<Bool>(value: false)
		}
	}
	
	func cleanToken() -> Promise<Void> {
		self.token = nil
		return Promise<Void>(value: ())
	}
	
	func checkAuthentication() -> Promise<AuthToken> {
		
		return checkToken().then(on: .global()) { (value) -> Promise<AuthToken> in
			
			if value {
				return Promise<AuthToken>(value: self.token!)
			} else {
				return self.cleanToken().then(on: .global()) {
					_ -> Promise<AuthToken> in
					
					if let email = self.email, let password = self.password {
						return self.authenticate(email: email, password: password)
					} else {
						throw TeslaError.authenticationRequired
					}
				}
				
			}
		}
	}
	
	func request<T: Mappable>(_ endpoint: Endpoint, body: Mappable? = nil) -> Promise<T> {
		
		let (promise, fulfill, reject) = Promise<T>.pending()
		
		let request = prepareRequest(endpoint, body: body)
		let debugEnabled = debuggingEnabled
		let task = URLSession.shared.dataTask(with: request, completionHandler: {
			(data, response, error) in
			
			logDebug("Respose: \(String(describing: response))", debuggingEnabled: debugEnabled)
			
			guard error == nil else { reject(error!); return }
			guard let httpResponse = response as? HTTPURLResponse else { reject(TeslaError.failedToParseData); return }
			
			if case 200..<300 = httpResponse.statusCode {
				
				if let data = data,
					let object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
					logDebug("Respose Body: \(object)", debuggingEnabled: debugEnabled)
					if let mapped = Mapper<T>().map(JSONObject: object) {
						fulfill(mapped)
					} else {
						reject(TeslaError.failedToParseData)
					}
				} else {
					reject(TeslaError.failedToParseData)
				}
				
			} else {
				if let data = data,
					let object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
					logDebug("Respose Body Error: \(object)", debuggingEnabled: debugEnabled)
					if let mapped = Mapper<ErrorMessage>().map(JSONObject: object) {
						reject(TeslaError.networkError(error: NSError(domain: "TeslaError", code: httpResponse.statusCode, userInfo:[ErrorInfo: mapped])))
					} else {
						reject(TeslaError.networkError(error: NSError(domain: "TeslaError", code: httpResponse.statusCode, userInfo: nil)))
					}
					
				} else {
					reject(TeslaError.networkError(error: NSError(domain: "TeslaError", code: httpResponse.statusCode, userInfo: nil)))
				}
			}
			
			
		}) 
		task.resume()
		
		return promise
	}
    
	func prepareRequest(_ endpoint: Endpoint, body: Mappable?) -> URLRequest {
	
		var request = URLRequest(url: URL(string: endpoint.baseURL(useMockServer) + endpoint.path)!)
		request.httpMethod = endpoint.method
		
		if let token = self.token?.accessToken {
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}
		
		if let body = body {
			let jsonObject = body.toJSON()
			request.httpBody = try? JSONSerialization.data(withJSONObject: jsonObject, options: [])
			request.setValue("application/json", forHTTPHeaderField: "content-type")
		}
		
		logDebug("Request: \(request)", debuggingEnabled: debuggingEnabled)
		logDebug("Request Headers: \(String(describing: request.allHTTPHeaderFields))", debuggingEnabled: debuggingEnabled)
		if let body = body {
			logDebug("Request Body: \(body.toJSONString(prettyPrint: true)!)", debuggingEnabled: debuggingEnabled)
		}
		
		return request
	}
	
}

func logDebug(_ format: String, debuggingEnabled: Bool) {
	if debuggingEnabled {
		NSLog(format)
	}
}
