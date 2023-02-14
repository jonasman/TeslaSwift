//
//  TeslaSwift.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 04/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import os.log

public enum TeslaError: Error, Equatable {
    case networkError(error: NSError)
    case authenticationRequired
    case authenticationFailed
    case tokenRevoked
    case noTokenToRefresh
    case tokenRefreshFailed
    case invalidOptionsForCommand
    case failedToParseData
    case failedToReloadVehicle
    case internalError
}

let ErrorInfo = "ErrorInfo"
private var nullBody = ""

open class TeslaSwift {
    open var debuggingEnabled = false

    open fileprivate(set) var token: AuthToken?

    open fileprivate(set) var email: String?
    fileprivate var password: String?

    public init() { }
}

extension TeslaSwift {

    public var isAuthenticated: Bool {
        return token != nil && (token?.isValid ?? false)
    }

    #if canImport(WebKit) && canImport(UIKit)
    /**
     Performs the authentication with the Tesla API for web logins

     For MFA users, this is the only way to authenticate.
     If the token expires, a token refresh will be done

     - returns: A ViewController that your app needs to present. This ViewController will ask the user for his/her Tesla credentials, MFA code if set and then dismiss on successful authentication.
     An async function that returns when the token as been retrieved
     */
    public func authenticateWeb() -> (TeslaWebLoginViewController?, () async throws -> AuthToken) {

        let codeRequest = AuthCodeRequest()
        let endpoint = Endpoint.oAuth2Authorization(auth: codeRequest)
        var urlComponents = URLComponents(string: endpoint.baseURL())
        urlComponents?.path = endpoint.path
        urlComponents?.queryItems = endpoint.queryParameters

        guard let safeUrlComponents = urlComponents else {
            func error() async throws -> AuthToken {
                throw TeslaError.authenticationFailed
            }
            return (nil, error)
        }

        let teslaWebLoginViewController = TeslaWebLoginViewController(url: safeUrlComponents.url!)

        func result() async throws -> AuthToken {
                let url = try await teslaWebLoginViewController.result()
                let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
                if let queryItems = urlComponents?.queryItems {
                    for queryItem in queryItems {
                        if queryItem.name == "code", let code = queryItem.value {
                            return try await self.getAuthenticationTokenForWeb(code: code)
                        }
                    }
                }
            throw TeslaError.authenticationFailed
        }
        return (teslaWebLoginViewController, result)
    }
    #endif

    private func getAuthenticationTokenForWeb(code: String) async throws -> AuthToken {

        let body = AuthTokenRequestWeb(code: code)

        do {
            let token: AuthToken = try await request(.oAuth2Token, body: body)
            self.token = token
            return token
        } catch let error {
            if case let TeslaError.networkError(error: internalError) = error {
                if internalError.code == 302 || internalError.code == 403 {
                    return try await self.request(.oAuth2TokenCN, body: body)
                } else if internalError.code == 401 {
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
     Performs the token refresh with the Tesla API for Web logins

     - returns: The AuthToken.
     */
    public func refreshWebToken() async throws -> AuthToken {
        guard let token = self.token else { throw TeslaError.noTokenToRefresh }
        let body = AuthTokenRequestWeb(grantType: .refreshToken, refreshToken: token.refreshToken)

        do {
            let authToken: AuthToken = try await request(.oAuth2Token, body: body)
            self.token = authToken
            return authToken
        } catch let error {
            if case let TeslaError.networkError(error: internalError) = error {
                if internalError.code == 302 || internalError.code == 403 {
                    //Handle redirection for tesla.cn
                    return try await self.request(.oAuth2TokenCN, body: body)
                } else if internalError.code == 401 {
                    throw TeslaError.tokenRefreshFailed
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
	
	This method is useful if your app wants to ask the user for credentials once and reuse the token skipping authentication
	If the token is invalid a new authentication will be required
	
	- parameter token:      The previous token
	- parameter email:      Email is required for streaming
	*/
	public func reuse(token: AuthToken, email: String? = nil) {
		self.token = token
		self.email = email
	}

    /**
     Revokes the stored token. Not working

     - returns: The token revoke state.
     */
    public func revokeWeb() async throws -> Bool {
        guard let accessToken = self.token?.accessToken else {
            cleanToken()
            return false
        }

        _ = try await checkAuthentication()
        self.cleanToken()

        let response: BoolResponse = try await request(.oAuth2revoke(token: accessToken), body: nullBody)
        return response.response
    }

	/**
	Removes all the information related to the previous authentication
	
	*/
	public func logout() {
		email = nil
		password = nil
		cleanToken()
        #if canImport(WebKit) && canImport(UIKit)
        TeslaWebLoginViewController.removeCookies()
        #endif
	}
	/**
	Fetchs the list of your vehicles including not yet delivered ones
	
	- returns: An array of Vehicles.
	*/
    public func getVehicles() async throws -> [Vehicle] {
        _ = try await checkAuthentication()
        let response: ArrayResponse<Vehicle> = try await request(.vehicles, body: nullBody)
        return response.response
	}
    
    /**
    Fetchs the list of your products
     
    - returns: An array of Products.
    */
    public func getProducts() async throws -> [Product] {
        _ = try await checkAuthentication()
        let response: ArrayResponse<Product> = try await request(.products, body: nullBody)
        return response.response
    }

    /**
     Fetches the currently authenticated user

     - returns: A User.
     */
    public func getUser() async throws -> User {
        _ = try await checkAuthentication()
        let response: Response<User> = try await request(.user, body: nullBody)
        return response.response
    }

    
    /**
    Fetchs the summary of a vehicle
    
    - returns: A Vehicle.
    */
    public func getVehicle(_ vehicleID: String) async throws -> Vehicle {
        _ = try await checkAuthentication()
        let response: Response<Vehicle> = try await request(.vehicleSummary(vehicleID: vehicleID), body: nullBody)
        return response.response
    }
    
    /**
    Fetches the summary of a vehicle
    
    - returns: A Vehicle.
    */
    public func getVehicle(_ vehicle: Vehicle) async throws -> Vehicle {
        return try await getVehicle(vehicle.id!)
    }
	
    /**
     Fetches the vehicle data
     
     - returns: A completion handler with all the data
     */
    public func getAllData(_ vehicleID: String) async throws -> VehicleExtended {
        _ = try await checkAuthentication()
        let response: Response<VehicleExtended> = try await request(.allStates(vehicleID: vehicleID), body: nullBody)
        return response.response
	}

    /**
     Fetches the vehicle data

     - returns: A completion handler with all the data
     */
    public func getAllData(_ vehicle: Vehicle) async throws -> VehicleExtended {
        return try await getAllData(vehicle.id!)
    }

	/**
	Fetches the vehicle mobile access state
	
	- returns: The mobile access state.
	*/
    public func getVehicleMobileAccessState(_ vehicle: Vehicle) async throws -> Bool {
        _ = try await checkAuthentication()
        let vehicleID = vehicle.id!
        let response: BoolResponse = try await request(.mobileAccess(vehicleID: vehicleID), body: nullBody)
        return response.response
    }
    
	/**
	Fetches the vehicle charge state
	
	- returns: The charge state.
	*/
	public func getVehicleChargeState(_ vehicle: Vehicle) async throws -> ChargeState {
        _ = try await checkAuthentication()
        let vehicleID = vehicle.id!
        let response: Response<ChargeState> = try await request(.chargeState(vehicleID: vehicleID), body: nullBody)
        return response.response
	}
	
	/**
	Fetches the vehicle Climate state
	
	- returns: The Climate state.
	*/
    public func getVehicleClimateState(_ vehicle: Vehicle) async throws -> ClimateState {
        _ = try await checkAuthentication()
        let vehicleID = vehicle.id!
        let response: Response<ClimateState> = try await request(.climateState(vehicleID: vehicleID), body: nullBody)
        return response.response
	}
	
	/**
	Fetches the vehicle drive state
	
	- returns: The drive state.
	*/
	public func getVehicleDriveState(_ vehicle: Vehicle) async throws -> DriveState {
        _ = try await checkAuthentication()
        let vehicleID = vehicle.id!
        let response: Response<DriveState> = try await request(.driveState(vehicleID: vehicleID), body: nullBody)
        return response.response
	}
	
	/**
	Fetches the vehicle GUI Settings
	
	- returns: The GUI Settings.
	*/
    public func getVehicleGuiSettings(_ vehicle: Vehicle) async throws -> GuiSettings {
        _ = try await checkAuthentication()
        let vehicleID = vehicle.id!
        let response: Response<GuiSettings> = try await request(.guiSettings(vehicleID: vehicleID), body: nullBody)
        return response.response
    }
	
	/**
	Fetches the vehicle state
	
	- returns: The vehicle state.
	*/
    public func getVehicleState(_ vehicle: Vehicle) async throws -> VehicleState {
        _ = try await checkAuthentication()
        let vehicleID = vehicle.id!
        let response: Response<VehicleState> = try await request(.vehicleState(vehicleID: vehicleID), body: nullBody)
        return response.response
    }
	
	/**
	Fetches the vehicle config
	
	- returns: The vehicle config
	*/
    public func getVehicleConfig(_ vehicle: Vehicle) async throws -> VehicleConfig {
        _ = try await checkAuthentication()
        let vehicleID = vehicle.id!
        let response: Response<VehicleConfig> = try await request(.vehicleConfig(vehicleID: vehicleID), body: nullBody)
        return response.response
    }

    /**
     Fetches the nearby charging sites

     - parameter vehicle: the vehicle to get nearby charging sites from
     - returns: The nearby charging sites
     */
    public func getNearbyChargingSites(_ vehicle: Vehicle) async throws -> NearbyChargingSites {
        _ = try await checkAuthentication()
        let vehicleID = vehicle.id!
        let response: Response<NearbyChargingSites> = try await request(.nearbyChargingSites(vehicleID: vehicleID), body: nullBody)
        return response.response
    }

	/**
	Wakes up the vehicle
	
	- returns: The current Vehicle
	*/
    public func wakeUp(_ vehicleID: String) async throws -> Vehicle {
        _ = try await checkAuthentication()
        let response: Response<Vehicle> = try await request(.wakeUp(vehicleID: vehicleID), body: nullBody)
        return response.response
	}

    /**
     Wakes up the vehicle

     - returns: The current Vehicle
     */
    public func wakeUp(_ vehicle: Vehicle) async throws -> Vehicle {
        return try await getAllData(vehicle.id!)
    }


    /**
     Sends a command to the vehicle

     - parameter vehicleID: the if od the vehicle that will receive the command
     - parameter command: the command to send to the vehicle
     - returns: A completion handler with the CommandResponse object containing the results of the command.
     */
    public func sendCommandToVehicle(_ vehicle: Vehicle, command: VehicleCommand) async throws -> CommandResponse {
        return try await sendCommandToVehicle(vehicle.id!, command: command)
    }
	/**
	Sends a command to the vehicle
	
	- parameter vehicle: the vehicle that will receive the command
	- parameter command: the command to send to the vehicle
	- returns: A completion handler with the CommandResponse object containing the results of the command.
	*/
	public func sendCommandToVehicle(_ vehicleID: String, command: VehicleCommand) async throws -> CommandResponse {
        _ = try await checkAuthentication()

        switch command {
            case let .setMaxDefrost(on: state):
                let body = MaxDefrostCommandOptions(state: state)
                return try await request(Endpoint.command(vehicleID: vehicleID, command: command), body: body)
            case let .triggerHomeLink(coordinates):
                let body = HomeLinkCommandOptions(coordinates: coordinates)
                return try await request(Endpoint.command(vehicleID: vehicleID, command: command), body: body)
            case let .valetMode(valetActivated, pin):
                let body = ValetCommandOptions(valetActivated: valetActivated, pin: pin)
                return try await request(Endpoint.command(vehicleID: vehicleID, command: command), body: body)
            case let .openTrunk(options):
                let body = options
                return try await request(Endpoint.command(vehicleID: vehicleID, command: command), body: body)
            case let .shareToVehicle(address):
                let body = address
                return try await request(Endpoint.command(vehicleID: vehicleID, command: command), body: body)
            case let .scheduledCharging(enable, time):
                let body = ScheduledChargingCommandOptions(enable: enable, time: time)
                return try await request(Endpoint.command(vehicleID: vehicleID, command: command), body: body)
            case let .scheduledDeparture(body):
                return try await request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body)
            case let .chargeLimitPercentage(limit):
                let body = ChargeLimitPercentageCommandOptions(limit: limit)
                return try await request(Endpoint.command(vehicleID: vehicleID, command: command), body: body)
            case let .setTemperature(driverTemperature, passengerTemperature):
                let body = SetTemperatureCommandOptions(driverTemperature: driverTemperature, passengerTemperature: passengerTemperature)
                return try await request(Endpoint.command(vehicleID: vehicleID, command: command), body: body)
            case let .setSunRoof(state, percent):
                let body = SetSunRoofCommandOptions(state: state, percent: percent)
                return try await request(Endpoint.command(vehicleID: vehicleID, command: command), body: body)
            case let .startVehicle(password):
                let body = RemoteStartDriveCommandOptions(password: password)
                return try await request(Endpoint.command(vehicleID: vehicleID, command: command), body: body)
            case let .speedLimitSetLimit(speed):
                let body = SetSpeedLimitOptions(limit: speed)
                return try await request(Endpoint.command(vehicleID: vehicleID, command: command), body: body)
            case let .speedLimitActivate(pin):
                let body = SpeedLimitPinOptions(pin: pin)
                return try await request(Endpoint.command(vehicleID: vehicleID, command: command), body: body)
            case let .speedLimitDeactivate(pin):
                let body = SpeedLimitPinOptions(pin: pin)
                return try await request(Endpoint.command(vehicleID: vehicleID, command: command), body: body)
            case let .speedLimitClearPin(pin):
                let body = SpeedLimitPinOptions(pin: pin)
                return try await request(Endpoint.command(vehicleID: vehicleID, command: command), body: body)
            case let .setSeatHeater(seat, level):
                let body = RemoteSeatHeaterRequestOptions(seat: seat, level: level)
                return try await request(Endpoint.command(vehicleID: vehicleID, command: command), body: body)
            case let .setSteeringWheelHeater(on):
                let body = RemoteSteeringWheelHeaterRequestOptions(on: on)
                return try await request(Endpoint.command(vehicleID: vehicleID, command: command), body: body)
            case let .sentryMode(activated):
                let body = SentryModeCommandOptions(activated: activated)
                return try await request(Endpoint.command(vehicleID: vehicleID, command: command), body: body)
            case let .windowControl(state):
                let body = WindowControlCommandOptions(command: state)
                return try await request(Endpoint.command(vehicleID: vehicleID, command: command), body: body)
            case let .setCharging(amps):
                let body = ChargeAmpsCommandOptions(amps: amps)
                return try await request(Endpoint.command(vehicleID: vehicleID, command: command), body: body)
            default:
                let body = nullBody
                return try await request(Endpoint.command(vehicleID: vehicleID, command: command), body: body)
        }
	}

    /**
    Fetchs the status of your energy site
     
    - returns: The EnergySiteStatus
    */
    public func getEnergySiteStatus(siteID: String) async throws -> EnergySiteStatus {
        _ = try await checkAuthentication()
        let response: Response<EnergySiteStatus> = try await request(.getEnergySiteStatus(siteID: siteID), body: nullBody)
        return response.response
    }
    
    /**
     Fetchs the live status of your energy site
     
    - returns: A completion handler with an array of Products.
    */
    public func getEnergySiteLiveStatus(siteID: String) async throws -> EnergySiteLiveStatus {
        _ = try await checkAuthentication()
        let response: Response<EnergySiteLiveStatus> = try await request(.getEnergySiteLiveStatus(siteID: siteID), body: nullBody)
        return response.response
    }
    
    /**
     Fetchs the info of your energy site
     
    - returns: The EnergySiteInfo.
    */
    public func getEnergySiteInfo(siteID: String) async throws -> EnergySiteInfo {
        _ = try await checkAuthentication()
        let response: Response<EnergySiteInfo> = try await request(.getEnergySiteInfo(siteID: siteID), body: nullBody)
        return response.response
    }
    
    /**
     Fetchs the history of your energy site
     
    - returns: The EnergySiteHistory
    */
    public func getEnergySiteHistory(siteID: String, period: EnergySiteHistory.Period) async throws  -> EnergySiteHistory {
        _ = try await checkAuthentication()
        let response: Response<EnergySiteHistory> = try await request(.getEnergySiteHistory(siteID: siteID, period: period), body: nullBody)
        return response.response
    }
    
    /**
     Fetchs the status of your Powerwall battery
     
    - returns: The BatteryStatus
    */
    public func getBatteryStatus(batteryID: String) async throws -> BatteryStatus {
        _ = try await checkAuthentication()
        let response: Response<BatteryStatus> = try await request(.getBatteryStatus(batteryID: batteryID), body: nullBody)
        return response.response
    }
    
    /**
     Fetchs the data of your Powerwall battery
     
    - returns: The BatteryData
    */
    public func getBatteryData(batteryID: String) async throws -> BatteryData {
        _ = try await checkAuthentication()
        let response: Response<BatteryData> = try await request(.getBatteryData(batteryID: batteryID), body: nullBody)
        return response.response
    }
    
    /**
     Fetchs the history of your Powerwall battery
     
    - returns: The BatteryPowerHistory
    */
    public func getBatteryPowerHistory(batteryID: String) async throws -> BatteryPowerHistory {
        _ = try await checkAuthentication()
        let response: Response<BatteryPowerHistory> = try await request(.getBatteryPowerHistory(batteryID: batteryID), body: nullBody)
        return response.response
    }
}

extension TeslaSwift {

    func checkToken() -> Bool {
        if let token = self.token {
            return token.isValid
        } else {
            return false
        }
    }

    func cleanToken() {
        token = nil
    }

    func checkAuthentication() async throws -> AuthToken {
        guard let token = self.token else { throw TeslaError.authenticationRequired }

        if checkToken() {
            return token
        } else {
            if token.refreshToken != nil {
                return try await refreshWebToken()
            } else {
                throw TeslaError.authenticationRequired
            }
        }
	}

    private func request<ReturnType: Decodable, BodyType: Encodable>(
        _ endpoint: Endpoint, body: BodyType
    ) async throws -> ReturnType {
        let request = prepareRequest(endpoint, body: body)
        let debugEnabled = debuggingEnabled

        let data: Data
        let response: URLResponse

        if #available(iOS 15.0, *) {
            (data, response) = try await URLSession.shared.data(for: request)
        } else {
            (data, response) = try await withCheckedThrowingContinuation { continuation in
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data, let response = response {
                        continuation.resume(with: .success((data, response)))
                    } else {
                        continuation.resume(with: .failure(error ?? TeslaError.internalError))
                    }
                }
            }
        }

        guard let httpResponse = response as? HTTPURLResponse else { throw TeslaError.failedToParseData }

        var responseString = "\nRESPONSE: \(String(describing: httpResponse.url))"
        responseString += "\nSTATUS CODE: \(httpResponse.statusCode)"
        if let headers = httpResponse.allHeaderFields as? [String: String] {
            responseString += "\nHEADERS: [\n"
            headers.forEach {(key: String, value: String) in
                responseString += "\"\(key)\": \"\(value)\"\n"
            }
            responseString += "]"
        }

        logDebug(responseString, debuggingEnabled: debugEnabled)

        if case 200..<300 = httpResponse.statusCode {
            do {
                let objectString = String.init(data: data, encoding: String.Encoding.utf8) ?? "No Body"
                logDebug("RESPONSE BODY: \(objectString)\n", debuggingEnabled: debugEnabled)

                let mapped = try teslaJSONDecoder.decode(ReturnType.self, from: data)
                return mapped
            } catch {
                logDebug("ERROR: \(error)", debuggingEnabled: debugEnabled)
                throw TeslaError.failedToParseData
            }
        } else {
            let objectString = String.init(data: data, encoding: String.Encoding.utf8) ?? "No Body"
            logDebug("RESPONSE BODY ERROR: \(objectString)\n", debuggingEnabled: debugEnabled)
            if let wwwAuthenticate = httpResponse.allHeaderFields["Www-Authenticate"] as? String,
               wwwAuthenticate.contains("invalid_token") {
                throw TeslaError.tokenRevoked
            } else if httpResponse.allHeaderFields["Www-Authenticate"] != nil, httpResponse.statusCode == 401 {
                throw TeslaError.authenticationFailed
            } else if let mapped = try? teslaJSONDecoder.decode(ErrorMessage.self, from: data) {
                throw TeslaError.networkError(error: NSError(domain: "TeslaError", code: httpResponse.statusCode, userInfo: [ErrorInfo: mapped]))
            } else {
                throw TeslaError.networkError(error: NSError(domain: "TeslaError", code: httpResponse.statusCode, userInfo: nil))
            }
        }
    }

    func prepareRequest<BodyType: Encodable>(_ endpoint: Endpoint, body: BodyType) -> URLRequest {
        var urlComponents = URLComponents(url: URL(string: endpoint.baseURL())!, resolvingAgainstBaseURL: true)
        urlComponents?.path = endpoint.path
        urlComponents?.queryItems = endpoint.queryParameters
        var request = URLRequest(url: urlComponents!.url!)
		request.httpMethod = endpoint.method
		
		request.setValue("TeslaSwift", forHTTPHeaderField: "User-Agent")
		
		if let token = self.token?.accessToken {
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}
		
		if let body = body as? String, body == nullBody {
            // Shrug
		} else {
			request.httpBody = try? teslaJSONEncoder.encode(body)
			request.setValue("application/json", forHTTPHeaderField: "content-type")
		}
		
		logDebug("\nREQUEST: \(request)", debuggingEnabled: debuggingEnabled)
		logDebug("METHOD: \(request.httpMethod!)", debuggingEnabled: debuggingEnabled)
		if let headers = request.allHTTPHeaderFields {
			var headersString = "REQUEST HEADERS: [\n"
			headers.forEach {(key: String, value: String) in
				headersString += "\"\(key)\": \"\(value)\"\n"
			}
			headersString += "]"
			logDebug(headersString, debuggingEnabled: debuggingEnabled)
		}
		
		if let body = body as? String, body != nullBody {
            // Shrug
		} else if let jsonString = body.jsonString {
			logDebug("REQUEST BODY: \(jsonString)", debuggingEnabled: debuggingEnabled)
		}
		
		return request
	}
	
}

func logDebug(_ format: String, debuggingEnabled: Bool) {
	if debuggingEnabled {
		print(format)
	}
}

public let teslaJSONEncoder: JSONEncoder = {
	let encoder = JSONEncoder()
	encoder.outputFormatting = .prettyPrinted
	encoder.dateEncodingStrategy = .secondsSince1970
	return encoder
}()

public let teslaJSONDecoder: JSONDecoder = {
	let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            if let dateDouble = try? container.decode(Double.self) {
                return Date(timeIntervalSince1970: dateDouble)
            } else {
                let dateString = try container.decode(String.self)
                let dateFormatter = ISO8601DateFormatter()
                var date = dateFormatter.date(from: dateString)
                guard let date = date else {
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
                }
                return date
            }
        })
	return decoder
}()
