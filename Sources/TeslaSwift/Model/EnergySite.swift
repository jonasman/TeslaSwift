//
//  EnergySite.swift
//  TeslaSwift
//
//  Created by Alec on 11/24/21.
//  Copyright © 2021 Joao Nunes. All rights reserved.
//

import Foundation

// MARK: - EnergySite
open class EnergySite: Codable {
    
    // Unique to EnergySite
    open var id: String?
    public var batteryId: BatteryId? {
        guard let id else { return nil }
        
        return BatteryId(id: id)
    }
    open var energySiteID: Decimal
    public var siteId: SiteId {
        SiteId(id: energySiteID)
    }
    open var siteName: String?
    open var assetSiteID: String?
    open var components: Components?
    open var goOffGridTestBannerEnabled: Bool?
    open var stormModeEnabled: Bool?
    open var powerwallOnboardingSettingsSet: Bool?
    open var powerwallTeslaElectricInterestedIn: String?
    open var vppTourEnabled: Bool?

    // Also available in EnergySiteStatus
    open var resourceType: String
    open var warpSiteNumber: String?
    open var gatewayID: String?
    open var energyLeft: Double?
    open var totalPackEnergy: Double?
    open var percentageCharged: Double?
    open var batteryType: String?
    open var backupCapable: Bool?
    open var batteryPower: Double?
    open var syncGridAlertEnabled: Bool?
    open var breakerAlertEnabled: Bool?

    enum CodingKeys: String, CodingKey {
        case siteName = "site_name"
        case energySiteID = "energy_site_id"
        case resourceType = "resource_type"
        case warpSiteNumber = "warp_site_number"
        case id
        case gatewayID = "gateway_id"
        case assetSiteID = "asset_site_id"
        case energyLeft = "energy_left"
        case totalPackEnergy = "total_pack_energy"
        case percentageCharged = "percentage_charged"
        case batteryType = "battery_type"
        case backupCapable = "backup_capable"
        case batteryPower = "battery_power"
        case syncGridAlertEnabled = "sync_grid_alert_enabled"
        case breakerAlertEnabled = "breaker_alert_enabled"
        case components
        case goOffGridTestBannerEnabled = "go_off_grid_test_banner_enabled"
        case stormModeEnabled = "storm_mode_enabled"
        case powerwallOnboardingSettingsSet = "powerwall_onboarding_settings_set"
        case powerwallTeslaElectricInterestedIn = "powerwall_tesla_electric_interested_in"
        case vppTourEnabled = "vpp_tour_enabled"
    }

    // MARK: - Components
    open class Components: Codable {
        open var battery: Bool
        open var batteryType: String?
        open var solar: Bool
        open var solarType: String?
        open var grid: Bool
        open var loadMeter: Bool
        open var marketType: String
        open var wallConnectors: [WallConnectors]?

        enum CodingKeys: String, CodingKey {
            case battery
            case batteryType = "battery_type"
            case solar
            case solarType = "solar_type"
            case grid
            case loadMeter = "load_meter"
            case marketType = "market_type"
            case wallConnectors = "wall_connectors"
        }
    }
}

open class WallConnectors: Codable {
    open var deviceId: String?
    open var din: String?
    open var partNumber: String?
    open var partType: Int?
    open var partName: String?
    open var isActive: Bool?

    enum CodingKeys: String, CodingKey {
        case deviceId = "device_id"
        case din
        case partNumber = "part_number"
        case partType = "part_type"
        case partName = "part_name"
        case isActive = "is_active"
    }

}
