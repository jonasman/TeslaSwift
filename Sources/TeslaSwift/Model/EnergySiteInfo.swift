//
//  EnergySiteInfo.swift
//  TeslaSwift
//
//  Created by Alec on 11/24/21.
//  Copyright © 2021 Joao Nunes. All rights reserved.
//

import Foundation

// MARK: - EnergySiteInfo
open class EnergySiteInfo: Codable {
    open var id: String
    open var siteName: String?
    open var backupReservePercent: Double?
    open var defaultRealMode: String?
    open var installationDate: Date
    open var version: String?
    open var batteryCount: Int?
    open var nameplatePower: Double?
    open var nameplateEnergy: Double?
    open var installationTimeZone: String
    open var offGridVehicleChargingReservePercent: Double?
    
    open var userSettings: UserSettings
    open var touSettings: TOUSettings?
    open var components: Components

    enum CodingKeys: String, CodingKey {
        case id
        case siteName = "site_name"
        case backupReservePercent = "backup_reserve_percent"
        case defaultRealMode = "default_real_mode"
        case installationDate = "installation_date"
        case userSettings = "user_settings"
        case components, version
        case batteryCount = "battery_count"
        case touSettings = "tou_settings"
        case nameplatePower = "nameplate_power"
        case nameplateEnergy = "nameplate_energy"
        case installationTimeZone = "installation_time_zone"
        case offGridVehicleChargingReservePercent = "off_grid_vehicle_charging_reserve_percent"
    }
    
    // MARK: - Components
    open class Components: Codable {
        open var solar: Bool
        open var solarType: String?
        open var battery: Bool
        open var grid: Bool
        open var backup: Bool
        open var gateway: String
        open var loadMeter: Bool
        open var touCapable: Bool?
        open var stormModeCapable: Bool?
        open var flexEnergyRequestCapable: Bool
        open var carChargingDataSupported: Bool
        open var offGridVehicleChargingReserveSupported: Bool
        open var vehicleChargingPerformanceViewEnabled: Bool
        open var vehicleChargingSolarOffsetViewEnabled: Bool
        open var batterySolarOffsetViewEnabled: Bool
        open var setIslandingModeEnabled: Bool?
        open var backupTimeRemainingEnabled: Bool?
        open var batteryType: String?
        open var configurable: Bool?
        open var gridServicesEnabled: Bool?

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
        }
    }

    // MARK: - TouSettings
    open class TOUSettings: Codable {
        open var optimizationStrategy: String
        open var schedule: [Schedule]

        enum CodingKeys: String, CodingKey {
            case optimizationStrategy = "optimization_strategy"
            case schedule
        }
    }

    // MARK: - Schedule
    open class Schedule: Codable {
        open var target: String
        open var weekDays: [Int]
        open var startSeconds: Int
        open var endSeconds: Int

        enum CodingKeys: String, CodingKey {
            case target
            case weekDays = "week_days"
            case startSeconds = "start_seconds"
            case endSeconds = "end_seconds"
        }
    }

    // MARK: - UserSettings
    open class UserSettings: Codable {
        open var stormModeEnabled: Bool?
        open var syncGridAlertEnabled: Bool
        open var breakerAlertEnabled: Bool

        enum CodingKeys: String, CodingKey {
            case stormModeEnabled = "storm_mode_enabled"
            case syncGridAlertEnabled = "sync_grid_alert_enabled"
            case breakerAlertEnabled = "breaker_alert_enabled"
        }
    }
}
