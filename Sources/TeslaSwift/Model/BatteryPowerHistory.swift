//
//  BatteryPowerHistory.swift
//  TeslaSwift
//
//  Created by Alec on 11/24/21.
//  Copyright © 2021 Joao Nunes. All rights reserved.
//

import Foundation

// MARK: - BatteryPowerHistory
final public class BatteryPowerHistory: Codable, Sendable {
    public let serialNumber: String
    public let timeSeries: [TimeSeries]
    public let selfConsumptionData: [SelfConsumptionDatum]

    enum CodingKeys: String, CodingKey {
        case serialNumber = "serial_number"
        case timeSeries = "time_series"
        case selfConsumptionData = "self_consumption_data"
    }
    
    // MARK: - SelfConsumptionDatum
    final public class SelfConsumptionDatum: Codable, Sendable {
        public let timestamp: Date
        public let solar: Double
        public let battery: Double
    }

    // MARK: - TimeSeries
    final public class TimeSeries: Codable, Sendable {
        public let timestamp: Date
        public let solarPower: Double
        public let batteryPower: Double
        public let gridPower: Double
        public let gridServicesPower: Double
        public let generatorPower: Double

        enum CodingKeys: String, CodingKey {
            case timestamp
            case solarPower = "solar_power"
            case batteryPower = "battery_power"
            case gridPower = "grid_power"
            case gridServicesPower = "grid_services_power"
            case generatorPower = "generator_power"
        }
    }
}
