//
//  EnergySiteLiveStatus.swift
//  TeslaSwift
//
//  Created by Alec on 11/24/21.
//  Copyright © 2021 Joao Nunes. All rights reserved.
//

import Foundation

// MARK: - EnergySiteLiveStatus
open class EnergySiteLiveStatus: Codable {
    open var solarPower: Double?
    open var energyLeft: Double?
    open var totalPackEnergy: Double?
    open var percentageCharged: Double?
    open var backupCapable: Bool?
    open var batteryPower: Double?
    open var loadPower: Double?
    open var gridStatus: String?
    open var gridServicesActive: Bool?
    open var gridPower: Double?
    open var gridServicesPower: Double?
    open var generatorPower: Double?
    open var islandStatus: String?
    open var stormModeActive: Bool?
    open var wallConnectors: [WallConnector]
    open var timestamp: Date

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

    open class WallConnector: Codable {
        open var din: String?
        open var wallConnectorState: Int?
        open var wallConnectorPower: Int?

        enum CodingKeys: String, CodingKey {
            case din
            case wallConnectorState = "wall_connector_state"
            case wallConnectorPower = "wall_connector_power"
        }
    }
}
