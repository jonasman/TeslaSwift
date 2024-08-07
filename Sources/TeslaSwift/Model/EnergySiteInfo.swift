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
    open var components: Components
    open var tariffContentV2: TariffV2?

    enum CodingKeys: String, CodingKey {
        case id
        case siteName = "site_name"
        case backupReservePercent = "backup_reserve_percent"
        case defaultRealMode = "default_real_mode"
        case installationDate = "installation_date"
        case userSettings = "user_settings"
        case components, version
        case tariffContentV2 = "tariff_content_v2"
        case batteryCount = "battery_count"
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
        open var wallConnectors: [WallConnectors]?

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
            case wallConnectors = "wall_connectors"
        }
    }
    
    // MARK: - SeasonPeriod
    open class SeasonPeriod: Codable {
        open var toDayOfWeek: Int?
        open var toHour: Int?
        open var toMinute: Int?
        open var fromDayOfWeek: Int?
        open var fromHour: Int?
        open var fromMinute: Int?
    }

    // MARK: - SeasonPeriods
    open class TariffV2: Codable {
        open var code: String
        open var name: String
        open var utility: String
        open var energyCharges: [String: EnergyChargeRates]
        open var seasons: [String: Season]
        open var sellTariff: SellTariff
        open var version: Int

        enum CodingKeys: String, CodingKey {
            case code
            case name
            case utility
            case energyCharges = "energy_charges"
            case seasons
            case sellTariff = "sell_tariff"
            case version
        }
    }

    // MARK: - SeasonPeriod
    open class SeasonPeriods: Codable {
        open var periods: [SeasonPeriod]

        enum CodingKeys: String, CodingKey {
            case periods
        }
    }

    // MARK: - Season
    open class Season: Codable {
        open var fromDay: Int
        open var toDay: Int
        open var fromMonth: Int
        open var toMonth: Int
        open var touPeriods: [String: SeasonPeriods]

        enum CodingKeys: String, CodingKey {
            case fromDay = "fromDay"
            case toDay = "toDay"
            case fromMonth = "fromMonth"
            case toMonth = "toMonth"
            case touPeriods = "tou_periods"
        }
    }

    // MARK: - EnergyChargeRates 
    open class EnergyChargeRates: Codable {
        open var rates: [String: Double]

        enum CodingKeys: String, CodingKey {
            case rates
        }
    }

    // MARK: - SellTariff
    open class SellTariff: Codable {
        open var name: String
        open var utility: String
        open var energyCharges: [String: EnergyChargeRates]
        open var seasons: [String: Season]

        enum CodingKeys: String, CodingKey {
            case name
            case utility
            case energyCharges = "energy_charges"
            case seasons
        }
    }
    // MARK: - UserSettings
    open class UserSettings: Codable {
        open var stormModeEnabled: Bool?
        open var syncGridAlertEnabled: Bool
        open var breakerAlertEnabled: Bool
        open var vppTourEnabled: Bool?
        open var goOffGridTestBannerEnabled: Bool?
        open var powerwallOnboardingSettingsSet: Bool?
        open var powerwallTeslaElectricInterestedIn: Bool?

        enum CodingKeys: String, CodingKey {
            case stormModeEnabled = "storm_mode_enabled"
            case syncGridAlertEnabled = "sync_grid_alert_enabled"
            case breakerAlertEnabled = "breaker_alert_enabled"
            case vppTourEnabled = "vpp_tour_enabled"
            case goOffGridTestBannerEnabled = "go_off_grid_test_banner_enabled"
            case powerwallOnboardingSettingsSet = "powerwall_onboarding_settings_set"
            case powerwallTeslaElectricInterestedIn = "powerwall_tesla_electric_interested_in"
        }
    }
}
