//
//  TeslaEndpoint.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 16/04/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation

enum Endpoint {
	
	case authentication
    case revoke
    case oAuth2Authorization(auth: AuthCodeRequest)
    case oAuth2AuthorizationCN(auth: AuthCodeRequest)
    case oAuth2Token
    case oAuth2TokenCN
    case oAuth2revoke(token: String)
    case oAuth2revokeCN(token: String)
	case vehicles
    case vehicleSummary(vehicleID: String)
	case mobileAccess(vehicleID: String)
	case allStates(vehicleID: String)
	case chargeState(vehicleID: String)
	case climateState(vehicleID: String)
	case driveState(vehicleID: String)
    case nearbyChargingSites(vehicleID: String)
	case guiSettings(vehicleID: String)
	case vehicleState(vehicleID: String)
	case vehicleConfig(vehicleID: String)
	case wakeUp(vehicleID: String)
	case command(vehicleID: String, command:VehicleCommand)
}

extension Endpoint {
	
    var path: String {
        switch self {
            case .authentication:
                return "/oauth/token"
            case .revoke:
                return "/oauth/revoke"
            case .oAuth2Authorization, .oAuth2AuthorizationCN:
                return "/oauth2/v3/authorize"
            case .oAuth2Token, .oAuth2TokenCN:
                return "/oauth2/v3/token"
            case .oAuth2revoke, .oAuth2revokeCN:
                return "/oauth2/v3/revoke"
            case .vehicles:
                return "/api/1/vehicles"
            case .vehicleSummary(let vehicleID):
                return "/api/1/vehicles/\(vehicleID)"
            case .mobileAccess(let vehicleID):
                return "/api/1/vehicles/\(vehicleID)/mobile_enabled"
            case .allStates(let vehicleID):
                return "/api/1/vehicles/\(vehicleID)/vehicle_data"
            case .chargeState(let vehicleID):
                return "/api/1/vehicles/\(vehicleID)/data_request/charge_state"
            case .climateState(let vehicleID):
                return "/api/1/vehicles/\(vehicleID)/data_request/climate_state"
            case .driveState(let vehicleID):
                return "/api/1/vehicles/\(vehicleID)/data_request/drive_state"
            case .guiSettings(let vehicleID):
                return "/api/1/vehicles/\(vehicleID)/data_request/gui_settings"
            case .nearbyChargingSites(let vehicleID):
                return "/api/1/vehicles/\(vehicleID)/nearby_charging_sites"
            case .vehicleState(let vehicleID):
                return "/api/1/vehicles/\(vehicleID)/data_request/vehicle_state"
            case .vehicleConfig(let vehicleID):
                return "/api/1/vehicles/\(vehicleID)/data_request/vehicle_config"
            case .wakeUp(let vehicleID):
                return "/api/1/vehicles/\(vehicleID)/wake_up"
            case let .command(vehicleID, command):
                return "/api/1/vehicles/\(vehicleID)/\(command.path())"
        }
	}
	
	var method: String {
		switch self {
            case .authentication, .revoke, .oAuth2Token, .oAuth2TokenCN, .wakeUp, .command:
			return "POST"
            case .vehicles, .vehicleSummary, .mobileAccess, .allStates, .chargeState, .climateState, .driveState, .guiSettings, .vehicleState, .vehicleConfig, .nearbyChargingSites, .oAuth2Authorization, .oAuth2revoke, .oAuth2AuthorizationCN, .oAuth2revokeCN:
			return "GET"
		}
	}

    var queryParameters: [URLQueryItem] {
        switch self {
            case let .oAuth2Authorization(auth):
                return auth.parameters()
            case let .oAuth2revoke(token):
                return [URLQueryItem(name: "token", value: token)]
            default:
                return []
        }
    }

    func baseURL(_ useMockServer: Bool = false) -> String {
        if useMockServer {
            let mockUrl = UserDefaults.standard.string(forKey: "mock_base_url")
            if mockUrl != nil && mockUrl!.count > 0 {
                return mockUrl!
            } else {
                return "https://private-623898-modelsapi.apiary-mock.com"
            }
        } else {
            switch self {
                case .oAuth2Authorization, .oAuth2Token, .oAuth2revoke:
                    return "https://auth.tesla.com"
                case .oAuth2AuthorizationCN, .oAuth2TokenCN, .oAuth2revokeCN:
                    return "https://auth.tesla.cn"
                default:
                    return "https://owner-api.teslamotors.com"
            }
        }
    }
}
