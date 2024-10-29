//
//  EnergySiteInfo.swift
//  TeslaSwift
//
//  Created by Alec on 11/24/21.
//  Copyright © 2021 Joao Nunes. All rights reserved.
//

import Foundation

// MARK: - EnergySiteInfo
final public class EnergySiteInfo: Codable, Sendable {
    public let id: String
    public let siteName: String?
    public let siteNumber: String?
    public let backupReservePercent: Double?
    public let defaultRealMode: String?
    public let installationDate: Date
    public let version: String?
    public let batteryCount: Int?
    public let nameplatePower: Double?
    public let nameplateEnergy: Double?
    public let installationTimeZone: String
    public let offGridVehicleChargingReservePercent: Double?
    
    public let userSettings: UserSettings
    public let touSettings: TOUSettings?
    public let components: Components

    enum CodingKeys: String, CodingKey {
        case id
        case siteName = "site_name"
        case siteNumber = "site_number"
        case backupReservePercent = "backup_reserve_percent"
        case defaultRealMode = "default_real_mode"
        case installationDate = "installation_date"
        case userSettings = "user_settings"
        case components
        case version
        case batteryCount = "battery_count"
        case touSettings = "tou_settings"
        case nameplatePower = "nameplate_power"
        case nameplateEnergy = "nameplate_energy"
        case installationTimeZone = "installation_time_zone"
        case offGridVehicleChargingReservePercent = "off_grid_vehicle_charging_reserve_percent"
    }
    
    // MARK: - Components
    final public class Components: Codable, Sendable {
        public let solar: Bool
        public let solarType: String?
        public let battery: Bool
        public let grid: Bool
        public let backup: Bool
        public let gateway: String
        public let loadMeter: Bool
        public let touCapable: Bool?
        public let stormModeCapable: Bool?
        public let flexEnergyRequestCapable: Bool
        public let carChargingDataSupported: Bool
        public let offGridVehicleChargingReserveSupported: Bool
        public let vehicleChargingPerformanceViewEnabled: Bool
        public let vehicleChargingSolarOffsetViewEnabled: Bool
        public let batterySolarOffsetViewEnabled: Bool
        public let setIslandingModeEnabled: Bool?
        public let backupTimeRemainingEnabled: Bool?
        public let batteryType: String?
        public let configurable: Bool?
        public let gridServicesEnabled: Bool?
        public let energyServiceSelfSchedulingEnabled: Bool?
        public let wallConnectors: [WallConnectors]?
        public let nbtSupported: Bool?

        enum CodingKeys: String, CodingKey {
            case solar
            case solarType = "solar_type"
            case battery, grid, backup, gateway
            case loadMeter = "load_meter"
            case touCapable = "tou_capable"
            case stormModeCapable = "storm_mode_capable"
            case flexEnergyRequestCapable = "flex_energy_request_capable"
            case carChargingDataSupported = "car_charging_data_supported"
            case offGridVehicleChargingReserveSupported = "off_grid_vehicle_charging_reserve_supported"
            case vehicleChargingPerformanceViewEnabled = "vehicle_charging_performance_view_enabled"
            case vehicleChargingSolarOffsetViewEnabled = "vehicle_charging_solar_offset_view_enabled"
            case batterySolarOffsetViewEnabled = "battery_solar_offset_view_enabled"
            case setIslandingModeEnabled = "set_islanding_mode_enabled"
            case backupTimeRemainingEnabled = "backup_time_remaining_enabled"
            case batteryType = "battery_type"
            case configurable
            case gridServicesEnabled = "grid_services_enabled"
            case energyServiceSelfSchedulingEnabled = "energy_service_self_scheduling_enabled"
            case wallConnectors = "wall_connectors"
            case nbtSupported = "nbt_supported"
        }
    }

    // MARK: - TouSettings
    final public class TOUSettings: Codable, Sendable {
        public let optimizationStrategy: String
        public let schedule: [Schedule]

        enum CodingKeys: String, CodingKey {
            case optimizationStrategy = "optimization_strategy"
            case schedule
        }
    }

    // MARK: - Schedule
    final public class Schedule: Codable, Sendable {
        public let target: String
        public let weekDays: [Int]
        public let startSeconds: Int
        public let endSeconds: Int

        enum CodingKeys: String, CodingKey {
            case target
            case weekDays = "week_days"
            case startSeconds = "start_seconds"
            case endSeconds = "end_seconds"
        }
    }

    // MARK: - UserSettings
    final public class UserSettings: Codable, Sendable {
        public let stormModeEnabled: Bool?
        public let syncGridAlertEnabled: Bool
        public let breakerAlertEnabled: Bool
        public let goOffGridTestBannerEnabled: Bool?
        public let powerwallOnboardingSettingsSet: Bool?
        public let powerwallTeslaElectricInterestedIn: Bool?
        public let vppTourEnabled: Bool?
        public let offGridVehicleChargingEnabled: Bool?

        enum CodingKeys: String, CodingKey {
            case stormModeEnabled = "storm_mode_enabled"
            case syncGridAlertEnabled = "sync_grid_alert_enabled"
            case breakerAlertEnabled = "breaker_alert_enabled"
            case goOffGridTestBannerEnabled = "go_off_grid_test_banner_enabled"
            case powerwallOnboardingSettingsSet = "powerwall_onboarding_settings_set"
            case powerwallTeslaElectricInterestedIn = "powerwall_tesla_electric_interested_in"
            case vppTourEnabled = "vpp_tour_enabled"
            case offGridVehicleChargingEnabled =  "off_grid_vehicle_charging_enabled"
        }
    }
}
