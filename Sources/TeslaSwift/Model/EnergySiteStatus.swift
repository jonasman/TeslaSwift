//
//  EnergySiteStatus.swift
//  TeslaSwift
//
//  Created by Alec on 11/24/21.
//  Copyright © 2021 Joao Nunes. All rights reserved.
//

import Foundation

// MARK: - EnergySiteStatus
final public class EnergySiteStatus: Codable, Sendable {
    public let resourceType: String
    public let siteName: String
    public let assetSiteId: String?
    public let goOffGridTestBannerEnabled: Bool?
    public let stormModeEnabled: Bool?
    public let powerwallOnboardingSettingsSet: Bool?
    public let powerwallTeslaElectricInterestedIn: Bool?
    public let vppTourEnabled: Bool?
    public let solarPower: Int?
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
        case resourceType = "resource_type"
        case siteName = "site_name"
        case solarPower = "solar_power"
        case assetSiteId = "asset_site_id"
        case goOffGridTestBannerEnabled = "go_off_grid_test_banner_enabled"
        case stormModeEnabled = "storm_mode_enabled"
        case powerwallOnboardingSettingsSet = "powerwall_onboarding_settings_set"
        case powerwallTeslaElectricInterestedIn = "powerwall_tesla_electric_interested_in"
        case vppTourEnabled = "vpp_tour_enabled"
        case gatewayID = "gateway_id"
        case energyLeft = "energy_left"
        case totalPackEnergy = "total_pack_energy"
        case percentageCharged = "percentage_charged"
        case batteryType = "battery_type"
        case backupCapable = "backup_capable"
        case batteryPower = "battery_power"
        case syncGridAlertEnabled = "sync_grid_alert_enabled"
        case breakerAlertEnabled = "breaker_alert_enabled"
    }
}
