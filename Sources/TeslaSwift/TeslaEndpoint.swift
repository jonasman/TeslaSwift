//
//  TeslaEndpoint.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 16/04/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation

enum Endpoint {
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
    case command(vehicleID: String, command: VehicleCommand)
    case products
    case getEnergySiteStatus(siteID: String)
    case getEnergySiteLiveStatus(siteID: String)
    case getEnergySiteInfo(siteID: String)
    case getEnergySiteHistory(siteID: String, period: EnergySiteHistory.Period)
    case getBatteryStatus(batteryID: String)
    case getBatteryData(batteryID: String)
    case getBatteryPowerHistory(batteryID: String)
    case user
}

extension Endpoint {

    var path: String {
        switch self {
            // Auth
        case .revoke:
            return "/oauth/revoke"
        case .oAuth2Authorization, .oAuth2AuthorizationCN:
            return "/oauth2/v3/authorize"
        case .oAuth2Token, .oAuth2TokenCN:
            return "/oauth2/v3/token"
        case .oAuth2revoke, .oAuth2revokeCN:
            return "/oauth2/v3/revoke"
            // Vehicle Data and Commands
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
        case .products:
            return "/api/1/products"
            
            // Energy Data
        case .getEnergySiteStatus(let siteID):
            return "/api/1/energy_sites/\(siteID)/site_status"
        case .getEnergySiteLiveStatus(let siteID):
            return "/api/1/energy_sites/\(siteID)/live_status"
        case .getEnergySiteInfo(let siteID):
            return "/api/1/energy_sites/\(siteID)/site_info"
        case .getEnergySiteHistory(let siteID, _):
            return "/api/1/energy_sites/\(siteID)/history"
        case .getBatteryStatus(let batteryID):
            return "/api/1/powerwalls/\(batteryID)/status"
        case .getBatteryData(let batteryID):
            return "/api/1/powerwalls/\(batteryID)/"
        case .getBatteryPowerHistory(let batteryID):
            return "/api/1/powerwalls/\(batteryID)/powerhistory"

            // User
        case .user:
            return "/api/1/users/me"
        }
    }

    var method: String {
        switch self {
        case .revoke, .oAuth2Token, .oAuth2TokenCN, .wakeUp, .command:
            return "POST"
        case .vehicles, .vehicleSummary, .mobileAccess, .allStates, .chargeState, .climateState, .driveState, .guiSettings, .vehicleState, .vehicleConfig, .nearbyChargingSites, .oAuth2Authorization, .oAuth2revoke, .oAuth2AuthorizationCN, .oAuth2revokeCN, .products, .getEnergySiteStatus, .getEnergySiteLiveStatus, .getEnergySiteInfo, .getEnergySiteHistory, .getBatteryStatus, .getBatteryData, .getBatteryPowerHistory, .user:
            return "GET"
        }
    }

    var queryParameters: [URLQueryItem] {
        switch self {
        case let .oAuth2Authorization(auth):
            return auth.parameters()
        case let .oAuth2revoke(token):
            return [URLQueryItem(name: "token", value: token)]
        case let .getEnergySiteHistory(_, period):
            return [URLQueryItem(name: "period", value: period.rawValue), URLQueryItem(name: "kind", value: "energy")]
        case .allStates(_):
            return [URLQueryItem(name: "let_sleep", value: "true")]
        case .vehicleSummary(_):
            return [URLQueryItem(name: "let_sleep", value: "true")]
        default:
            return []
        }
    }

    func baseURL() -> String {
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
