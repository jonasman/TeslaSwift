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

    case me
    case region

    case partnerAccounts
	case vehicles
    case vehicleSummary(vehicleID: VehicleId)
	case mobileAccess(vehicleID: VehicleId)
	case allStates(vehicleID: VehicleId)
	case chargeState(vehicleID: VehicleId)
	case climateState(vehicleID: VehicleId)
	case driveState(vehicleID: VehicleId)
    case nearbyChargingSites(vehicleID: VehicleId)
	case guiSettings(vehicleID: VehicleId)
	case vehicleState(vehicleID: VehicleId)
	case vehicleConfig(vehicleID: VehicleId)
	case wakeUp(vehicleID: VehicleId)
	case command(vehicleID: VehicleId, command: VehicleCommand)
    case signedCommand(vehicleID: VehicleId)
    case products
    case chargeHistory(vehicleID: VehicleId)
    case getEnergySiteStatus(siteID: SiteId)
    case getEnergySiteLiveStatus(siteID: SiteId)
    case getEnergySiteInfo(siteID: SiteId)
    case getEnergySiteHistory(siteID: SiteId, period: EnergySiteHistory.Period)
    case getBatteryStatus(batteryID: BatteryId)
    case getBatteryData(batteryID: BatteryId)
    case getBatteryPowerHistory(batteryID: BatteryId)
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
            case .partnerAccounts:
                return "/api/1/partner_accounts"

            case .me:
                return "/api/1/users/me"
            case .region:
                return "/api/1/users/region"
            // Vehicle Data and Commands
            case .vehicles:
                return "/api/1/vehicles"
            case .vehicleSummary(let vehicleID):
                return "/api/1/vehicles/\(vehicleID.id)"
            case .mobileAccess(let vehicleID):
                return "/api/1/vehicles/\(vehicleID.id)/mobile_enabled"
            case .allStates(let vehicleID):
                return "/api/1/vehicles/\(vehicleID.id)/vehicle_data"
            case .chargeState(let vehicleID):
                return "/api/1/vehicles/\(vehicleID.id)/data_request/charge_state"
            case .climateState(let vehicleID):
                return "/api/1/vehicles/\(vehicleID.id)/data_request/climate_state"
            case .driveState(let vehicleID):
                return "/api/1/vehicles/\(vehicleID.id)/data_request/drive_state"
            case .guiSettings(let vehicleID):
                return "/api/1/vehicles/\(vehicleID.id)/data_request/gui_settings"
            case .nearbyChargingSites(let vehicleID):
                return "/api/1/vehicles/\(vehicleID.id)/nearby_charging_sites"
            case .vehicleState(let vehicleID):
                return "/api/1/vehicles/\(vehicleID.id)/data_request/vehicle_state"
            case .vehicleConfig(let vehicleID):
                return "/api/1/vehicles/\(vehicleID.id)/data_request/vehicle_config"
            case .wakeUp(let vehicleID):
                return "/api/1/vehicles/\(vehicleID.id)/wake_up"
            case let .command(vehicleID, command):
                return "/api/1/vehicles/\(vehicleID.id)/\(command.path())"
            case let .signedCommand(vehicleID):
                return "/api/1/vehicles/\(vehicleID.id)/signed_command"
            case .products:
                return "/api/1/products"
            case let .chargeHistory(vehicleID):
                return "/api/1/vehicles/\(vehicleID.id)/charge_history"

            // Energy Data
            case .getEnergySiteStatus(let siteID):
                return "/api/1/energy_sites/\(siteID.id)/site_status"
            case .getEnergySiteLiveStatus(let siteID):
                return "/api/1/energy_sites/\(siteID.id)/live_status"
            case .getEnergySiteInfo(let siteID):
                return "/api/1/energy_sites/\(siteID)/site_info"
            case .getEnergySiteHistory(let siteID, _):
                return "/api/1/energy_sites/\(siteID.id)/history"
            case .getBatteryStatus(let batteryID):
                return "/api/1/powerwalls/\(batteryID.id)/status"
            case .getBatteryData(let batteryID):
                return "/api/1/powerwalls/\(batteryID.id)/"
            case .getBatteryPowerHistory(let batteryID):
                return "/api/1/powerwalls/\(batteryID.id)/powerhistory"
        }
	}
	
	var method: String {
		switch self {
            case .revoke, .oAuth2Token, .oAuth2TokenCN, .wakeUp, .partnerAccounts, .chargeHistory, .command, .signedCommand:
                return "POST"
            case .me, .region, .vehicles, .vehicleSummary, .mobileAccess, .allStates, .chargeState, .climateState, .driveState, .guiSettings, .vehicleState, .vehicleConfig, .nearbyChargingSites, .oAuth2Authorization, .oAuth2revoke, .oAuth2AuthorizationCN, .oAuth2revokeCN, .products, .getEnergySiteStatus, .getEnergySiteLiveStatus, .getEnergySiteInfo, .getEnergySiteHistory, .getBatteryStatus, .getBatteryData, .getBatteryPowerHistory:
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
            default:
                return []
        }
    }

    func baseURL(teslaAPI: TeslaAPI) -> String {
        switch self {
            case .oAuth2Authorization, .oAuth2Token, .oAuth2revoke:
                return "https://auth.tesla.com"
            case .oAuth2AuthorizationCN, .oAuth2TokenCN, .oAuth2revokeCN:
                return "https://auth.tesla.cn"
            default:
                return teslaAPI.url
        }
    }
}
