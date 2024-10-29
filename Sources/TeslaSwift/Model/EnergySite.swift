//
//  EnergySite.swift
//  TeslaSwift
//
//  Created by Alec on 11/24/21.
//  Copyright © 2021 Joao Nunes. All rights reserved.
//

import Foundation

// MARK: - EnergySite
final public class EnergySite: Codable, Sendable {

    // Unique to EnergySite
    public let id: String?
    public var batteryId: BatteryId? {
        guard let id else { return nil }

        return BatteryId(id: id)
    }
    public let energySiteID: Decimal
    public var siteId: SiteId {
        SiteId(id: energySiteID)
    }
    public let siteName: String?
    public let assetSiteID: String?
    public let components: Components?
    public let goOffGridTestBannerEnabled: Bool?
    public let stormModeEnabled: Bool?
    public let powerwallOnboardingSettingsSet: Bool?
    public let powerwallTeslaElectricInterestedIn: String?
    public let vppTourEnabled: Bool?

    // Also available in EnergySiteStatus
    public let resourceType: String
    public let warpSiteNumber: String?
    public let gatewayID: String?
    public let energyLeft: Double?
    public let totalPackEnergy: Double?
    public let percentageCharged: Double?
    public let batteryType: String?
    public let backupCapable: Bool?
    public let batteryPower: Double?
    public let syncGridAlertEnabled: Bool
    public let breakerAlertEnabled: Bool

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
    final public class Components: Codable, Sendable {
        public let battery: Bool
        public let batteryType: String?
        public let solar: Bool
        public let solarType: String?
        public let grid: Bool
        public let loadMeter: Bool
        public let marketType: String
        public let wallConnectors: [WallConnectors]?

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

final public class WallConnectors: Codable, Sendable {
    public let deviceId: String?
    public let din: String?
    public let partNumber: String?
    public let partType: Int?
    public let partName: String?
    public let isActive: Bool?

    enum CodingKeys: String, CodingKey {
        case deviceId = "device_id"
        case din
        case partNumber = "part_number"
        case partType = "part_type"
        case partName = "part_name"
        case isActive = "is_active"
    }

}
