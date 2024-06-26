//
//  Vehicle.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 05/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation

open class Vehicle: Codable {
	
	open var backseatToken: String?
	open var backseatTokenUpdatedAt: Date?
	open var calendarEnabled: Bool?
	open var color: String?
	open var displayName: String?
	open var id: VehicleId? {
		get {
			guard let value = idInt else { return nil }
			return VehicleId(id: value)
		}
		set {
            guard let newValue = newValue?.id else { idInt = nil; return }
            idInt = newValue
		}
	}
	open var idInt: Int64?
	open var idS: String?
	open var inService: Bool?
	open var optionCodes: String?
	open var state: String?
	open var tokens: [String]?
	open var vehicleID: Int64?
	open var vin: String?

    // fields via /api/1/products
    open var userId: Int64?
    open var accessType: String?
    open var cachedData: String?
    open var apiVersion: Int?
    open var bleAutopairEnrolled: Bool?
    open var commandSigning: Bool?
    open var releaseNotesSupported: Bool?

	// MARK: Codable protocol
	
	enum CodingKeys: String, CodingKey {
		
		case backseatToken			 = "backseat_token"
		case backseatTokenUpdatedAt	 = "backseat_token_updated_at"
		case calendarEnabled			 = "calendar_enabled"
		case color					 = "color"
		case displayName				 = "display_name"
		case idInt						= "id"
		case idS						 = "id_s"
		case inService				 = "in_service"
		case optionCodes				 = "option_codes"
		case state					 = "state"
		case tokens					 = "tokens"
		case vehicleID				 = "vehicle_id"
		case vin						 = "vin"
        case userId                   = "user_id"
        case accessType               = "access_type"
        case cachedData               = "cached_data"
        case apiVersion               = "api_version"
        case bleAutopairEnrolled       = "ble_autopair_enrolled"
        case commandSigning            = "command_signing"
        case releaseNotesSupported     = "release_notes_supported"

	}
	
	required public init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: CodingKeys.self)
		backseatToken = try? container.decode(String.self, forKey: .backseatToken)
		backseatTokenUpdatedAt = try? container.decode(Date.self, forKey: .backseatTokenUpdatedAt)
		calendarEnabled = {
			if let boolValue = try? container.decode(Bool.self, forKey: .calendarEnabled) {
				return boolValue
			} else if let intValue = try? container.decode(Int.self, forKey: .calendarEnabled) {
					return intValue > 0
			} else {
				return nil
			}
		}()
		color = try? container.decode(String.self, forKey: .color)
		displayName = try? container.decode(String.self, forKey: .displayName)
		idInt = try? container.decode(Int64.self, forKey: .idInt)
		idS = try? container.decode(String.self, forKey: .idS)
		inService = {
			if let boolValue = try? container.decode(Bool.self, forKey: .inService) {
				return boolValue
			} else if let intValue = try? container.decode(Int.self, forKey: .inService) {
				return intValue > 0
			} else {
				return nil
			}
		}()
		optionCodes = try? container.decode(String.self, forKey: .optionCodes)
		state = try? container.decode(String.self, forKey: .state)
		tokens = try? container.decode([String].self, forKey: .tokens)
		vehicleID = try? container.decode(Int64.self, forKey: .vehicleID)
		vin = try? container.decode(String.self, forKey: .vin)
        userId = try? container.decode(Int64.self, forKey: .userId)
        accessType = try? container.decode(String.self, forKey: .accessType)
        cachedData = try? container.decode(String.self, forKey: .cachedData)
        apiVersion = try? container.decode(Int.self, forKey: .apiVersion)
        bleAutopairEnrolled = try? container.decode(Bool.self, forKey: .bleAutopairEnrolled)
        commandSigning = try? container.decode(Bool.self, forKey: .commandSigning)
        releaseNotesSupported  = try? container.decode(Bool.self, forKey: .releaseNotesSupported)
	}
	
	public func encode(to encoder: Encoder) throws {
		
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(backseatToken, forKey: .backseatToken)
		try container.encodeIfPresent(backseatTokenUpdatedAt, forKey: .backseatTokenUpdatedAt)
		try container.encodeIfPresent(calendarEnabled, forKey: .calendarEnabled)
		try container.encodeIfPresent(color, forKey: .color)
		try container.encodeIfPresent(displayName, forKey: .displayName)
		try container.encodeIfPresent(idInt, forKey: .idInt)
		try container.encodeIfPresent(idS, forKey: .idS)
		try container.encodeIfPresent(inService, forKey: .inService)
		try container.encodeIfPresent(optionCodes, forKey: .optionCodes)
		try container.encodeIfPresent(state, forKey: .state)
		try container.encodeIfPresent(tokens, forKey: .tokens)
		try container.encodeIfPresent(vehicleID, forKey: .vehicleID)
		try container.encodeIfPresent(vin, forKey: .vin)
        try container.encodeIfPresent(userId, forKey: .userId)
        try container.encodeIfPresent(accessType, forKey: .accessType)
        try container.encodeIfPresent(cachedData, forKey: .cachedData)
        try container.encodeIfPresent(apiVersion, forKey: .apiVersion)
        try container.encodeIfPresent(bleAutopairEnrolled, forKey: .bleAutopairEnrolled)
        try container.encodeIfPresent(commandSigning, forKey: .commandSigning)
        try container.encodeIfPresent(releaseNotesSupported, forKey: .releaseNotesSupported)
	}
}

public class VehicleId {
    public let id: Int64

    init(id: Int64) {
        self.id = id
    }
}

public class SiteId {
    public let id: Decimal

    init(id: Decimal) {
        self.id = id
    }
}

public class BatteryId {
    public let id: String

    init(id: String) {
        self.id = id
    }
}
