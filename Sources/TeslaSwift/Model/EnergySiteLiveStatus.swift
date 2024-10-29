//
//  EnergySiteLiveStatus.swift
//  TeslaSwift
//
//  Created by Alec on 11/24/21.
//  Copyright © 2021 Joao Nunes. All rights reserved.
//

import Foundation

// MARK: - EnergySiteLiveStatus
final public class EnergySiteLiveStatus: Codable, Sendable {
    public let solarPower: Double?
    public let energyLeft: Double?
    public let totalPackEnergy: Double?
    public let percentageCharged: Double?
    public let backupCapable: Bool?
    public let batteryPower: Double?
    public let loadPower: Double?
    public let gridStatus: String?
    public let gridServicesActive: Bool?
    public let gridPower: Double?
    public let gridServicesPower: Double?
    public let generatorPower: Double?
    public let islandStatus: String?
    public let stormModeActive: Bool?
    public let wallConnectors: [WallConnector]
    public let timestamp: Date

    enum CodingKeys: String, CodingKey {
        case solarPower = "solar_power"
        case energyLeft = "energy_left"
        case totalPackEnergy = "total_pack_energy"
        case percentageCharged = "percentage_charged"
        case backupCapable = "backup_capable"
        case batteryPower = "battery_power"
        case loadPower = "load_power"
        case gridStatus = "grid_status"
        case gridServicesActive = "grid_services_active"
        case gridPower = "grid_power"
        case gridServicesPower = "grid_services_power"
        case generatorPower = "generator_power"
        case islandStatus = "island_status"
        case stormModeActive = "storm_mode_active"
        case wallConnectors = "wall_connectors"
        case timestamp
    }

    final public class WallConnector: Codable, Sendable {
        public let din: String?
        public let wallConnectorState: Int?
        public let wallConnectorPower: Int?

        enum CodingKeys: String, CodingKey {
            case din
            case wallConnectorState = "wall_connector_state"
            case wallConnectorPower = "wall_connector_power"
        }
    }
}
