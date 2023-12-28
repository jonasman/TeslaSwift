//
//  EnergySite.swift
//  TeslaSwift
//
//  Created by Alec on 11/24/21.
//  Copyright © 2021 Joao Nunes. All rights reserved.
//

import Foundation

// MARK: - EnergySite
open class EnergySite: Codable {
    
    // Unique to EnergySite
    open var id: String?
    public var batteryId: BatteryId? {
        guard let id else { return nil }
        
        return BatteryId(id: id)
    }
    open var energySiteID: Decimal
    public var siteId: SiteId {
        SiteId(id: energySiteID)
    }
    open var assetSiteID: String?
    open var components: Components?
    
    // Also available in EnergySiteStatus
    open var resourceType: String
    open var siteName: String?
    open var gatewayID: String?
    open var energyLeft: Double?
    open var totalPackEnergy: Double?
    open var percentageCharged: Double?
    open var batteryType: String?
    open var backupCapable: Bool?
    open var batteryPower: Double?
    open var syncGridAlertEnabled: Bool
    open var breakerAlertEnabled: Bool

    enum CodingKeys: String, CodingKey {
        case energySiteID = "energy_site_id"
        case resourceType = "resource_type"
        case siteName = "site_name"
        case id
        case gatewayID = "gateway_id"
        case assetSiteID = "asset_site_id"
        case energyLeft = "energy_left"
        case totalPackEnergy = "total_pack_energy"
        case percentageCharged = "percentage_charged"
        case batteryType = "battery_type"
        case backupCapable = "backup_capable"
        case batteryPower = "battery_power"
        case syncGridAlertEnabled = "sync_grid_alert_enabled"
        case breakerAlertEnabled = "breaker_alert_enabled"
        case components
    }

    // MARK: - Components
    open class Components: Codable {
        open var battery: Bool
        open var batteryType: String?
        open var solar: Bool
        open var solarType: String?
        open var grid: Bool
        open var loadMeter: Bool
        open var marketType: String

        enum CodingKeys: String, CodingKey {
            case battery
            case batteryType = "battery_type"
            case solar
            case solarType = "solar_type"
            case grid
            case loadMeter = "load_meter"
            case marketType = "market_type"
        }
    }
}
