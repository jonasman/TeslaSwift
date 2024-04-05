//
//  VehicleExtended.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 12/03/2017.
//  Copyright © 2017 Joao Nunes. All rights reserved.
//

import Foundation

open class VehicleExtended: Vehicle {
	open var chargeState: ChargeState?
	open var climateState: ClimateState?
	open var driveState: DriveState?
	open var guiSettings: GuiSettings?
	open var vehicleConfig: VehicleConfig?
	open var vehicleState: VehicleState?

	private enum CodingKeys: String, CodingKey {
		case userId			 = "user_id"
		case chargeState		 = "charge_state"
		case climateState	 = "climate_state"
		case driveState		 = "drive_state"
		case guiSettings		 = "gui_settings"
		case vehicleConfig	 = "vehicle_config"
		case vehicleState	 = "vehicle_state"
        
        case superWorkaround = "super" // We need this to be able to decode from the Tesla API and from an encoded string
	}
	
	required public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		chargeState = try container.decodeIfPresent(ChargeState.self, forKey: .chargeState)
		climateState = try container.decodeIfPresent(ClimateState.self, forKey: .climateState)
		driveState = try container.decodeIfPresent(DriveState.self, forKey: .driveState)
		guiSettings = try container.decodeIfPresent(GuiSettings.self, forKey: .guiSettings)
		vehicleConfig = try container.decodeIfPresent(VehicleConfig.self, forKey: .vehicleConfig)
		vehicleState = try container.decodeIfPresent(VehicleState.self, forKey: .vehicleState)
        if container.contains(.superWorkaround) {
            try super.init(from: container.superDecoder() )
        } else {
            try super.init(from: decoder)
        }
	}
	
	override open func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(chargeState, forKey: .chargeState)
		try container.encodeIfPresent(climateState, forKey: .climateState)
		try container.encodeIfPresent(driveState, forKey: .driveState)
		try container.encodeIfPresent(guiSettings, forKey: .guiSettings)
		try container.encodeIfPresent(vehicleConfig, forKey: .vehicleConfig)
		try container.encodeIfPresent(vehicleState, forKey: .vehicleState)
		
		let superEncoder = container.superEncoder()
		try super.encode(to: superEncoder)
	}
}
