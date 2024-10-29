//
//  BatteryStatus.swift
//  TeslaSwift
//
//  Created by Alec on 11/24/21.
//  Copyright © 2021 Joao Nunes. All rights reserved.
//

import Foundation

// MARK: - BatteryStatus
final public class BatteryStatus: Codable, Sendable {
    public let siteName: String
    public let id: String
    public let energyLeft: Double
    public let totalPackEnergy: Double
    public let percentageCharged: Double
    public let batteryPower: Double

    enum CodingKeys: String, CodingKey {
        case siteName = "site_name"
        case id
        case energyLeft = "energy_left"
        case totalPackEnergy = "total_pack_energy"
        case percentageCharged = "percentage_charged"
        case batteryPower = "battery_power"
    }
}
