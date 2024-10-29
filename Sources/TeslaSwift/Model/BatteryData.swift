//
//  BatteryData.swift
//  TeslaSwift
//
//  Created by Alec on 11/24/21.
//  Copyright © 2021 Joao Nunes. All rights reserved.
//

import Foundation

// MARK: - Welcome
final public class BatteryData: Codable, Sendable {
    public let energyLeft: Double
    public let totalPackEnergy: Double
    public let gridStatus: String
    public let defaultRealMode: String
    public let operation: String
    public let installationDate: Date
    public let batteryCount: Int
    public let backup: Backup
    public let userSettings: UserSettings
    public let components: Components
    public let powerReading: [PowerReading]

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
    final public class Backup: Codable, Sendable {
        public let backupReservePercent: Double
        public let events: [Event]

        enum CodingKeys: String, CodingKey {
            case backupReservePercent = "backup_reserve_percent"
            case events
        }
    }

    // MARK: - Event
    final public class Event: Codable, Sendable {
        let timestamp: Date
        let duration: Int
    }

    // MARK: - Components
    final public class Components: Codable, Sendable {
        public let solar: Bool
        public let solarType: String
        public let battery: Bool
        public let grid: Bool
        public let backup: Bool
        public let gateway: String
        public let loadMeter: Bool
        public let touCapable: Bool
        public let stormModeCapable: Bool
        public let flexEnergyRequestCapable: Bool
        public let carChargingDataSupported: Bool
        public let offGridVehicleChargingReserveSupported: Bool
        public let vehicleChargingPerformanceViewEnabled: Bool
        public let vehicleChargingSolarOffsetViewEnabled: Bool
        public let batterySolarOffsetViewEnabled: Bool
        public let setIslandingModeEnabled: Bool
        public let backupTimeRemainingEnabled: Bool
        public let batteryType: String
        public let configurable: Bool
        public let gridServicesEnabled: Bool

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
    final public class PowerReading: Codable, Sendable {
        public let timestamp: Date
        public let loadPower: Double
        public let solarPower: Double
        public let gridPower: Double
        public let batteryPower: Double
        public let generatorPower: Double

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
    final public class UserSettings: Codable, Sendable {
        public let stormModeEnabled: Bool
        public let syncGridAlertEnabled: Bool
        public let breakerAlertEnabled: Bool

        enum CodingKeys: String, CodingKey {
            case stormModeEnabled = "storm_mode_enabled"
            case syncGridAlertEnabled = "sync_grid_alert_enabled"
            case breakerAlertEnabled = "breaker_alert_enabled"
        }
    }
}
