//
//  BatteryData.swift
//  TeslaSwift
//
//  Created by Alec on 11/24/21.
//  Copyright © 2021 Joao Nunes. All rights reserved.
//

import Foundation

// MARK: - Welcome
open class BatteryData: Codable {
    open var energyLeft: Double
    open var totalPackEnergy: Double
    open var gridStatus: String
    open var defaultRealMode: String
    open var operation: String
    open var installationDate: Date
    open var batteryCount: Int
    open var backup: Backup
    open var userSettings: UserSettings
    open var components: Components
    open var powerReading: [PowerReading]

    enum CodingKeys: String, CodingKey {
        case energyLeft = "energy_left"
        case totalPackEnergy = "total_pack_energy"
        case gridStatus = "grid_status"
        case backup
        case userSettings = "user_settings"
        case components
        case defaultRealMode = "default_real_mode"
        case operation
        case installationDate = "installation_date"
        case powerReading = "power_reading"
        case batteryCount = "battery_count"
    }
    
    // MARK: - Backup
    open class Backup: Codable {
        open var backupReservePercent: Double
        open var events: [Event]

        enum CodingKeys: String, CodingKey {
            case backupReservePercent = "backup_reserve_percent"
            case events
        }
    }

    // MARK: - Event
    open class Event: Codable {
        let timestamp: Date
        let duration: Int
    }

    // MARK: - Components
    open class Components: Codable {
        open var solar: Bool
        open var solarType: String
        open var battery: Bool
        open var grid: Bool
        open var backup: Bool
        open var gateway: String
        open var loadMeter: Bool
        open var touCapable: Bool
        open var stormModeCapable: Bool
        open var flexEnergyRequestCapable: Bool
        open var carChargingDataSupported: Bool
        open var offGridVehicleChargingReserveSupported: Bool
        open var vehicleChargingPerformanceViewEnabled: Bool
        open var vehicleChargingSolarOffsetViewEnabled: Bool
        open var batterySolarOffsetViewEnabled: Bool
        open var setIslandingModeEnabled: Bool
        open var backupTimeRemainingEnabled: Bool
        open var batteryType: String
        open var configurable: Bool
        open var gridServicesEnabled: Bool

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

    // MARK: - PowerReading
    open class PowerReading: Codable {
        open var timestamp: Date
        open var loadPower: Double
        open var solarPower: Double
        open var gridPower: Double
        open var batteryPower: Double
        open var generatorPower: Double

        enum CodingKeys: String, CodingKey {
            case timestamp
            case loadPower = "load_power"
            case solarPower = "solar_power"
            case gridPower = "grid_power"
            case batteryPower = "battery_power"
            case generatorPower = "generator_power"
        }
    }

    // MARK: - UserSettings
    open class UserSettings: Codable {
        open var stormModeEnabled: Bool
        open var syncGridAlertEnabled: Bool
        open var breakerAlertEnabled: Bool

        enum CodingKeys: String, CodingKey {
            case stormModeEnabled = "storm_mode_enabled"
            case syncGridAlertEnabled = "sync_grid_alert_enabled"
            case breakerAlertEnabled = "breaker_alert_enabled"
        }
    }
}
