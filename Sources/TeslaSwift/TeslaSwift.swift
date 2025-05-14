//
//  TeslaSwift.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 04/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import os
import SafariServices
import WebKit

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
    case noCodeInURL
}

public enum TeslaAPI {

    public enum Region: String, Codable {
        case northAmericaAsiaPacific = "https://fleet-api.prd.na.vn.cloud.tesla.com"
        case europeMiddleEastAfrica = "https://fleet-api.prd.eu.vn.cloud.tesla.com"
        case china = "https://fleet-api.prd.cn.vn.cloud.tesla.cn"
    }
    
    public enum Scope: String {
        case openId = "openid"
        case offlineAccess = "offline_access"
        case userData = "user_data"
        case vehicleDeviceData = "vehicle_device_data"
        case vehicleCmds = "vehicle_cmds"
        case vehicleChargingCmds = "vehicle_charging_cmds"
        case energyDeviceData = "energy_device_data"
        case energyCmds = "energy_cmds"

        public static var all: [Scope] = [.openId, .offlineAccess, .userData, .vehicleDeviceData, .vehicleCmds, .vehicleChargingCmds, .energyDeviceData, .energyCmds]
    }

    case ownerAPI
    case fleetAPI(region: Region, clientID: String, clientSecret: String, redirectURI: String, scopes: [Scope] = Scope.all)

    var url: String {
        switch self {
            case .ownerAPI: return "https://owner-api.teslamotors.com"
            case let .fleetAPI(region: region, clientID: _, clientSecret: _, redirectURI: _, scopes: _): return region.rawValue
        }
    }
}

open class TeslaSwift {
    open var debuggingEnabled = false

    open fileprivate(set) var token: AuthToken?
    open fileprivate(set) var partnerToken: AuthToken?

    open fileprivate(set) var email: String?
    fileprivate var password: String?

    let teslaAPI: TeslaAPI

    public init(teslaAPI: TeslaAPI) {
        self.teslaAPI = teslaAPI
    }

    private let logger = Logger(subsystem: "Tesla Swift", category: "Tesla Swift")
}

//MARK: Partner APIs
public extension TeslaSwift {

    /**
     Retrieves a partner Auth token

     This is not to be used in client apps, but only to help register your Tesla app

     - returns: An Auth token
     */
    func getPartnerToken() async throws -> AuthToken {

        let body = AuthTokenRequestWeb(teslaAPI: teslaAPI, grantType: .clientCredentials)

        do {
            let token: AuthToken = try await request(.oAuth2Token, body: body)
            self.partnerToken = token
            return token
        } catch let error {
            if case let TeslaError.networkError(error: internalError) = error {
                if internalError.code == 302 || internalError.code == 403 {
                    let token: AuthToken = try await request(.oAuth2TokenCN, body: body)
                    self.partnerToken = token
                    return token
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
     Registers the app with Tesla

     This is not to be used in client apps, but only to help register your Tesla app

     - parameter domain: The domain where your public key is hosted
     - returns: The associated public key with this app and a few more details about the app
     */
    func registerApp(domain: String) async throws -> PartnerResponse {

        let body = PartnerBody(domain: domain)

        let response: PartnerResponse = try await request(.partnerAccounts, body: body)
        return response
    }
}

//MARK: Authentication APIs
extension TeslaSwift {

    public var isAuthenticated: Bool {
        return token != nil && (token?.isValid ?? false)
    }

    /**
     Performs the authentication with the Tesla API for web logins

     If the token expires, a token refresh will be done

     Capture the token like this:
     ```
     func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
         let token = try await api.authenticateWebNative(url: url)
     }
     ```
     - parameter delegate: An optional `SFSafariViewControllerDelegate` to receive the cancel event.
     - returns: A `SFSafariViewController` that your app needs to present. This ViewController will ask the user for his/her Tesla credentials, MFA code and then you will get a callback in your AppDelegate with the code to complete authentication.
     */
    #if ios
    public func authenticateWeb(delegate: SFSafariViewControllerDelegate? = nil) -> SFSafariViewController? {

        let codeRequest = AuthCodeRequest(teslaAPI: teslaAPI)
        let endpoint = Endpoint.oAuth2Authorization(auth: codeRequest)
        var urlComponents = URLComponents(string: endpoint.baseURL(teslaAPI: teslaAPI))
        urlComponents?.path = endpoint.path
        urlComponents?.queryItems = endpoint.queryParameters

        guard let safeUrlComponents = urlComponents else {
            return nil
        }

        let safariViewController = SFSafariViewController(url: safeUrlComponents.url!)
        safariViewController.dismissButtonStyle = .cancel

        return safariViewController
    }
    #endif

    /**
     Creates a URL for Native browser authentication, open with  UIApplication.shared.open(url)

     If the Auth is successful, the Tesla login will call your Redirect URI. Get the callback url with this code in your AppDelegate:
     ```
     func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let token = try await api.authenticateWebNative(url: url)
     }
     ```

     - returns: the URL to open
     */
    public func authenticateWebNativeURL() -> URL? {
        let codeRequest = AuthCodeRequest(teslaAPI: teslaAPI)
        let endpoint = Endpoint.oAuth2Authorization(auth: codeRequest)
        var urlComponents = URLComponents(string: endpoint.baseURL(teslaAPI: teslaAPI))
        urlComponents?.path = endpoint.path
        urlComponents?.queryItems = endpoint.queryParameters

        return urlComponents?.url
    }

    /**
     Authenticates the API based on the code receveid in the URL call back from the Tesla Authenticartion website

     If the code is not found, this function will throw a TeslaError.noCodeInURL

     - returns: the Authentication Token
     */
    public func authenticateWebNative(url: URL) async throws -> AuthToken {
        if let code = parseCode(url: url) {
            return try await getAuthenticationTokenForWeb(code: code)
        } else {
            throw TeslaError.noCodeInURL
        }
    }

    func parseCode(url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let codeQueryItem = components?.queryItems?.first(where: { $0.name == "code" })
        return codeQueryItem?.value
    }

    private func getAuthenticationTokenForWeb(code: String) async throws -> AuthToken {

        let body = AuthTokenRequestWeb(teslaAPI: teslaAPI, code: code)

        do {
            let token: AuthToken = try await request(.oAuth2Token, body: body)
            self.token = token
            return token
        } catch let error {
            if case let TeslaError.networkError(error: internalError) = error {
                if internalError.code == 302 || internalError.code == 403 {
                    let token: AuthToken = try await request(.oAuth2TokenCN, body: body)
                    self.token = token
                    return token
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
     Performs the token refresh with the Tesla API

     - returns: The AuthToken.
     */
    public func refreshToken() async throws -> AuthToken {
        guard let token = self.token else { throw TeslaError.noTokenToRefresh }
        let body = AuthTokenRequestWeb(teslaAPI: teslaAPI, grantType: .refreshToken, refreshToken: token.refreshToken)

        do {
            let authToken: AuthToken = try await request(.oAuth2Token, body: body)
            self.token = authToken
            return authToken
        } catch let error {
            if case let TeslaError.networkError(error: internalError) = error {
                if internalError.code == 302 || internalError.code == 403 {
                    //Handle redirection for tesla.cn
                    let authToken: AuthToken = try await request(.oAuth2TokenCN, body: body)
                    self.token = authToken
                    return authToken
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
    public func revokeToken() async throws -> Bool {
        guard let accessToken = self.token?.accessToken else {
            cleanToken()
            return false
        }

        _ = try await checkAuthentication()
        self.cleanToken()

        let response: BoolResponse = try await request(.oAuth2revoke(token: accessToken))
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
        Self.removeCookies()
        #endif
    }

    static func removeCookies() {
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }

    /**
     Create a URL to send your public key to vehicle.
     Old Model S and X do not need to call this function
     Your website must include the pem file in doman/.well-known/appspecific/com.tesla.3p.public-key.pem

     Call this function after the user has authenticated then use UIApplication.shared.open(url)

     - parameter domain: The domain where your public key is hosted
     - returns: The URL for your app to open to register the public key in the vehicle
     */
    public func urlToSendPublicKeyToVehicle(domain: String) -> URL? {
        return URL(string: "https://tesla.com/_ak/\(domain)")
    }
}

//MARK: User APIs
extension TeslaSwift {
    /**
     Fetchs info about the user

     - returns: the user info
     */
    public func me() async throws -> Me {
        _ = try await checkAuthentication()
        let response: Response<Me> = try await request(.me)
        return response.response
    }

    /**
     Fetchs the user region

     - returns: the user region
     */
    public func region() async throws -> Region {
        _ = try await checkAuthentication()
        let response: Response<Region> = try await request(.region)
        return response.response
    }
}

//MARK: Control APIs
extension TeslaSwift {
	/**
	Fetchs the list of your vehicles including not yet delivered ones
	
	- returns: An array of Vehicles.
	*/
    public func getVehicles() async throws -> [Vehicle] {
        _ = try await checkAuthentication()
        let response: ArrayResponse<Vehicle> = try await request(.vehicles)
        return response.response
	}
    
    /**
    Fetchs the list of your products
     
    - returns: An array of Products.
    */
    public func getProducts() async throws -> [Product] {
        _ = try await checkAuthentication()
        let response: ArrayResponse<Product> = try await request(.products)
        return response.response
    }
    
    /**
    Fetchs the summary of a vehicle
    
    - returns: A Vehicle.
    */
    public func getVehicle(_ vehicleID: VehicleId) async throws -> Vehicle {
        _ = try await checkAuthentication()
        let response: Response<Vehicle> = try await request(.vehicleSummary(vehicleID: vehicleID))
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
     Wakes up the vehicle

     - returns: The current Vehicle
     */
    public func wakeUp(_ vehicle: Vehicle) async throws -> Vehicle {
        _ = try await checkAuthentication()
        let vehicleID = vehicle.id!
        let response: Response<Vehicle> = try await request(.wakeUp(vehicleID: vehicleID))
        return response.response
    }

    /**
     Fetches the vehicle data
     
     - returns: A completion handler with all the data
     */
    public func getAllData(_ vehicle: Vehicle, endpoints: [AllStatesEndpoints] = AllStatesEndpoints.allWithLocation) async throws -> VehicleExtended {
        _ = try await checkAuthentication()
        let vehicleID = vehicle.id!
        let response: Response<VehicleExtended> = try await request(.allStates(vehicleID: vehicleID, endpoints: endpoints))
        return response.response
	}
	
	/**
	Fetches the vehicle mobile access state
	
	- returns: The mobile access state.
	*/
    public func getVehicleMobileAccessState(_ vehicle: Vehicle) async throws -> Bool {
        _ = try await checkAuthentication()
        let vehicleID = vehicle.id!
        let response: BoolResponse = try await request(.mobileAccess(vehicleID: vehicleID))
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
        let response: Response<NearbyChargingSites> = try await request(.nearbyChargingSites(vehicleID: vehicleID))
        return response.response
    }

    /**
     Fetches the charge history for a vehicle

     - parameter vehicle: the vehicle to get charge history
     - returns: The charge history
     */
    public func getChargeHistory(_ vehicle: Vehicle) async throws -> ChargeHistory {
        _ = try await checkAuthentication()
        let vehicleID = vehicle.id!
        let response: Response<ChargeHistory> = try await request(.chargeHistory(vehicleID: vehicleID))
        return response.response
    }
	
	/**
	Sends a command to the vehicle
	
	- parameter vehicle: the vehicle that will receive the command
	- parameter command: the command to send to the vehicle
	- returns: A CommandResponse object containing the results of the command.
	*/
	public func sendCommandToVehicle(_ vehicle: Vehicle, command: VehicleCommand) async throws -> CommandResponse {
        _ = try await checkAuthentication()

        switch command {
            case let .setMaxDefrost(on: state):
                let body = MaxDefrostCommandOptions(state: state)
                return try await request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body)
            case let .triggerHomeLink(coordinates):
                let body = HomeLinkCommandOptions(coordinates: coordinates)
                return try await request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body)
            case let .valetMode(valetActivated, pin):
                let body = ValetCommandOptions(valetActivated: valetActivated, pin: pin)
                return try await request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body)
            case let .openTrunk(options):
                let body = options
                return try await request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body)
            case let .shareToVehicle(address):
                let body = address
                return try await request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body)
            case let .scheduledCharging(enable, time):
                let body = ScheduledChargingCommandOptions(enable: enable, time: time)
                return try await request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body)
            case let .scheduledDeparture(body):
                return try await request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body)
            case let .chargeLimitPercentage(limit):
                let body = ChargeLimitPercentageCommandOptions(limit: limit)
                return try await request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body)
            case let .setTemperature(driverTemperature, passengerTemperature):
                let body = SetTemperatureCommandOptions(driverTemperature: driverTemperature, passengerTemperature: passengerTemperature)
                return try await request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body)
            case let .setSunRoof(state, percent):
                let body = SetSunRoofCommandOptions(state: state, percent: percent)
                return try await request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body)
            case let .startVehicle(password):
                let body = RemoteStartDriveCommandOptions(password: password)
                return try await request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body)
            case let .speedLimitSetLimit(speed):
                let body = SetSpeedLimitOptions(limit: speed)
                return try await request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body)
            case let .speedLimitActivate(pin):
                let body = SpeedLimitPinOptions(pin: pin)
                return try await request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body)
            case let .speedLimitDeactivate(pin):
                let body = SpeedLimitPinOptions(pin: pin)
                return try await request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body)
            case let .speedLimitClearPin(pin):
                let body = SpeedLimitPinOptions(pin: pin)
                return try await request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body)
            case let .setSeatHeater(seat, level):
                let body = RemoteSeatHeaterRequestOptions(seat: seat, level: level)
                return try await request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body)
            case let .setSteeringWheelHeater(on):
                let body = RemoteSteeringWheelHeaterRequestOptions(on: on)
                return try await request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body)
            case let .sentryMode(activated):
                let body = SentryModeCommandOptions(activated: activated)
                return try await request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body)
            case let .windowControl(state):
                let body = WindowControlCommandOptions(command: state)
                return try await request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body)
            case let .setCharging(amps):
                let body = ChargeAmpsCommandOptions(amps: amps)
                return try await request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body)
            default:
                return try await request(Endpoint.command(vehicleID: vehicle.id!, command: command))
        }
	}


    /**
     Sends a signed command to the vehicle

     - parameter vehicle: the vehicle that will receive the command
     - parameter command: the command to send to the vehicle
     - returns: A CommandResponse object containing the results of the command.
     */
    public func sendSignedCommandToVehicle(_ vehicle: Vehicle, command: VehicleCommand) async throws -> CommandResponse {
        _ = try await checkAuthentication()
        let body = "" // TODO
        return try await request(Endpoint.signedCommand(vehicleID: vehicle.id!), body: body)
    }
    /**
    Fetchs the status of your energy site
     
    - returns: The EnergySiteStatus
    */
    public func getEnergySiteStatus(siteID: SiteId) async throws -> EnergySiteStatus {
        _ = try await checkAuthentication()
        let response: Response<EnergySiteStatus> = try await request(.getEnergySiteStatus(siteID: siteID))
        return response.response
    }
    
    /**
     Fetchs the live status of your energy site
     
    - returns: A completion handler with an array of Products.
    */
    public func getEnergySiteLiveStatus(siteID: SiteId) async throws -> EnergySiteLiveStatus {
        _ = try await checkAuthentication()
        let response: Response<EnergySiteLiveStatus> = try await request(.getEnergySiteLiveStatus(siteID: siteID))
        return response.response
    }
    
    /**
     Fetchs the info of your energy site
     
    - returns: The EnergySiteInfo.
    */
    public func getEnergySiteInfo(siteID: SiteId) async throws -> EnergySiteInfo {
        _ = try await checkAuthentication()
        let response: Response<EnergySiteInfo> = try await request(.getEnergySiteInfo(siteID: siteID))
        return response.response
    }
    
    /**
     Fetchs the history of your energy site
     
    - returns: The EnergySiteHistory
    */
    public func getEnergySiteHistory(siteID: SiteId, period: EnergySiteHistory.Period) async throws  -> EnergySiteHistory {
        _ = try await checkAuthentication()
        let response: Response<EnergySiteHistory> = try await request(.getEnergySiteHistory(siteID: siteID, period: period))
        return response.response
    }
    
    /**
     Fetchs the status of your Powerwall battery
     
    - returns: The BatteryStatus
    */
    public func getBatteryStatus(batteryID: BatteryId) async throws -> BatteryStatus {
        _ = try await checkAuthentication()
        let response: Response<BatteryStatus> = try await request(.getBatteryStatus(batteryID: batteryID))
        return response.response
    }
    
    /**
     Fetchs the data of your Powerwall battery
     
    - returns: The BatteryData
    */
    public func getBatteryData(batteryID: BatteryId) async throws -> BatteryData {
        _ = try await checkAuthentication()
        let response: Response<BatteryData> = try await request(.getBatteryData(batteryID: batteryID))
        return response.response
    }
    
    /**
     Fetchs the history of your Powerwall battery
     
    - returns: The BatteryPowerHistory
    */
    public func getBatteryPowerHistory(batteryID: BatteryId) async throws -> BatteryPowerHistory {
        _ = try await checkAuthentication()
        let response: Response<BatteryPowerHistory> = try await request(.getBatteryPowerHistory(batteryID: batteryID))
        return response.response
    }
}

//MARK: Helpers
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
        partnerToken = nil
    }

    func checkAuthentication() async throws -> AuthToken {
        guard let token = self.token else { throw TeslaError.authenticationRequired }

        if checkToken() {
            return token
        } else {
            if token.refreshToken != nil {
                return try await refreshToken()
            } else {
                throw TeslaError.authenticationRequired
            }
        }
	}

    private func request<ReturnType: Decodable>(
        _ endpoint: Endpoint
    ) async throws -> ReturnType {
        try await request(endpoint, body: Optional<String>.none)
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
                }.resume()
            }
        }

        guard let httpResponse = response as? HTTPURLResponse else { throw TeslaError.failedToParseData }

        var debugString = "RESPONSE: \(String(describing: httpResponse.url))"
        debugString += "\nSTATUS CODE: \(httpResponse.statusCode)"
        if let headers = httpResponse.allHeaderFields as? [String: String] {
            debugString += "\nHEADERS: [\n"
            headers.forEach {(key: String, value: String) in
                debugString += "\"\(key)\": \"\(value)\"\n"
            }
            debugString += "]"
        }

        if case 200..<300 = httpResponse.statusCode {
            do {
                let objectString = String.init(data: data, encoding: String.Encoding.utf8) ?? "No Body"
                debugString += "\nRESPONSE BODY: \(objectString)\n"
                logDebug(debugString, debuggingEnabled: debugEnabled)

                let mapped = try teslaJSONDecoder.decode(ReturnType.self, from: data)
                return mapped
            } catch {
                debugString += "\nERROR: \(error)"
                logDebug(debugString, debuggingEnabled: debugEnabled)
                throw TeslaError.failedToParseData
            }
        } else {
            let objectString = String.init(data: data, encoding: String.Encoding.utf8) ?? "No Body"
            debugString += "\nRESPONSE BODY ERROR: \(objectString)\n"
            logDebug(debugString, debuggingEnabled: debugEnabled)
            if let wwwAuthenticate = httpResponse.allHeaderFields["Www-Authenticate"] as? String,
               wwwAuthenticate.contains("invalid_token") {
                token?.expiresIn = 0
                throw TeslaError.tokenRevoked
            } else if httpResponse.allHeaderFields["Www-Authenticate"] != nil, httpResponse.statusCode == 401 {
                throw TeslaError.authenticationFailed
            } else if let mapped = try? teslaJSONDecoder.decode(ErrorMessage.self, from: data) {
                if mapped.error == "invalid bearer token" {
                    token?.expiresIn = 0
                    throw TeslaError.tokenRevoked
                } else {
                    throw TeslaError.networkError(error: NSError(domain: "TeslaError", code: httpResponse.statusCode, userInfo: ["ErrorInfo": mapped]))
                }
            } else {
                throw TeslaError.networkError(error: NSError(domain: "TeslaError", code: httpResponse.statusCode, userInfo: nil))
            }
        }
    }

    func prepareRequest<BodyType: Encodable>(_ endpoint: Endpoint, body: BodyType) -> URLRequest {
        var urlComponents = URLComponents(url: URL(string: endpoint.baseURL(teslaAPI: teslaAPI))!, resolvingAgainstBaseURL: true)
        urlComponents?.path = endpoint.path
        urlComponents?.queryItems = endpoint.queryParameters
        let percentEncodedQuery = urlComponents?.percentEncodedQuery
        // Tesla requires semicolons to be encoded in the query, so we force .urlQueryAllowed on the query params to remove the semicolon
        urlComponents?.percentEncodedQuery = percentEncodedQuery?.replacingOccurrences(of: ";", with: "%3B")
        var request = URLRequest(url: urlComponents!.url!)
		request.httpMethod = endpoint.method
		
		request.setValue("TeslaSwift", forHTTPHeaderField: "User-Agent")
        request.setValue("TeslaApp/4.30.6", forHTTPHeaderField: "x-tesla-user-agent")

		if let token = self.token?.accessToken {
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else if let token = self.partnerToken?.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if case let Optional<Encodable>.some(body) = body as Any {
            request.httpBody = try? teslaJSONEncoder.encode(body)
            request.setValue("application/json", forHTTPHeaderField: "content-type")
        }

        var debugString = ""

        debugString += "REQUEST: \(request)"
        debugString += "\nMETHOD: \(request.httpMethod!)"
		if let headers = request.allHTTPHeaderFields {
			var headersString = "\nREQUEST HEADERS: [\n"
			headers.forEach {(key: String, value: String) in
				headersString += "\"\(key)\": \"\(value)\"\n"
			}
			headersString += "]"
            debugString += headersString
		}
		
        if case let Optional<Encodable>.some(body) = body as Any, let jsonString = body.jsonString {
            debugString += "\nREQUEST BODY: \(jsonString)"
		}

        logDebug(debugString, debuggingEnabled: debuggingEnabled)

		return request
	}

    private func logDebug(_ format: String, debuggingEnabled: Bool) {
        if debuggingEnabled {
            logger.debug("\(format)")
        }
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
