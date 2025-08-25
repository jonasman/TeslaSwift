//
//  VehicleState.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 20/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation

open class VehicleState: Codable {
	
	open class MediaState: Codable {
		open var remoteControlEnabled: Bool?
		
		enum CodingKeys: String, CodingKey {
			case remoteControlEnabled = "remote_control_enabled"
		}
	}
	
	open class SpeedLimitMode: Codable {
		open var active: Bool?
		open var currentLimit: Measurement<UnitSpeed>?
		open var maxLimit: Measurement<UnitSpeed>?
		open var minLimit: Measurement<UnitSpeed>?
		open var pinCodeSet: Bool?
		
		enum CodingKeys: String, CodingKey {
			case active = "active"
			case currentLimit = "current_limit_mph"
			case maxLimit = "max_limit_mph"
			case minLimit = "min_limit_mph"
			case pinCodeSet = "pin_code_set"
		}
		
		required public init(from decoder: Decoder) throws {
			
			func milesDecoder(container: KeyedDecodingContainer<VehicleState.SpeedLimitMode.CodingKeys>, key: CodingKeys) -> Measurement<UnitSpeed>? {
				if let value = try? container.decode(Double.self, forKey: key) {
					return Measurement<UnitSpeed>(value: value, unit: UnitSpeed.milesPerHour)
				}
				return nil
			}
			
			let container = try decoder.container(keyedBy: CodingKeys.self)
			
			active = try? container.decode(Bool.self, forKey: .active)
			currentLimit = milesDecoder(container: container, key: .currentLimit)
			maxLimit = milesDecoder(container: container, key: .maxLimit)
			minLimit = milesDecoder(container: container, key: .minLimit)
			pinCodeSet = try? container.decode(Bool.self, forKey: .pinCodeSet)
		}
		
		public func encode(to encoder: Encoder) throws {
			
			var container = encoder.container(keyedBy: CodingKeys.self)
			
			try container.encodeIfPresent(active, forKey: .active)
			try container.encodeIfPresent(currentLimit?.value, forKey: .currentLimit)
			try container.encodeIfPresent(maxLimit?.value, forKey: .maxLimit)
			try container.encodeIfPresent(minLimit?.value, forKey: .minLimit)
			try container.encodeIfPresent(pinCodeSet, forKey: .pinCodeSet)
			
		}
		
	}
	
	open var apiVersion: Int?
	
	open var autoparkState: String?
	open var autoparkStateV2: String?
	open var autoparkStyle: String?
	
	open var calendarSupported: Bool?
	
	open var firmwareVersion: String?
	
	private var centerDisplayStateBool: Int?
	open var centerDisplayState: Bool? { return centerDisplayStateBool == 1 }
	
	private var driverDoorOpenBool: Int?
	open var driverDoorOpen: Bool? { return (driverDoorOpenBool ?? 0) > 0 }
    private var driverWindowOpenBool: Int?
    open var driverWindowOpen: Bool? { return (driverWindowOpenBool ?? 0) > 0 }

	private var driverRearDoorOpenBool: Int?
	open var driverRearDoorOpen: Bool? { return (driverRearDoorOpenBool ?? 0) > 0 }
    private var driverRearWindowOpenBool: Int?
    open var driverRearWindowOpen: Bool? { return (driverRearWindowOpenBool ?? 0) > 0 }
	
	private var frontTrunkOpenBool: Int?
	open var frontTrunkOpen: Bool? { return (frontTrunkOpenBool ?? 0) > 0 }
	
	open var homelinkNearby: Bool?
    open var homelinkDeviceCount: Int?
	open var isUserPresent: Bool?
	
	open var lastAutoparkError: String?
	
	open var locked: Bool?
	
	open var mediaState: MediaState?
	
	open var notificationsSupported: Bool?
	
	open var odometer: Double?
	
	open var parsedCalendarSupported: Bool?
	
	private var passengerDoorOpenBool: Int?
	open var passengerDoorOpen: Bool? { return (passengerDoorOpenBool ?? 0) > 0 }
    private var passengerWindowOpenBool: Int?
    open var passengerWindowOpen: Bool? { return (passengerWindowOpenBool ?? 0) > 0 }

	private var passengerRearDoorOpenBool: Int?
	open var passengerRearDoorOpen: Bool? { return (passengerRearDoorOpenBool ?? 0) > 0 }
    private var passengerRearWindowOpenBool: Int?
    open var passengerRearWindowOpen: Bool? { return (passengerRearWindowOpenBool ?? 0) > 0 }
	
	open var remoteStart: Bool?
	open var remoteStartSupported: Bool?
	
	private var rearTrunkOpenInt: Int?
	open var rearTrunkOpen: Bool? {
		if let rearTrunkOpenInt = rearTrunkOpenInt {
			return rearTrunkOpenInt > 0
		} else {
			return false
		}
	}
	
	open var sentryMode: Bool?
    
    open var softwareUpdate: SoftwareUpdate?
	open var speedLimitMode: SpeedLimitMode?
	
	open var sunRoofPercentageOpen: Int? // null if not installed
	open var sunRoofState: String?
	
	open var timeStamp: Double?
    
    open var tpms_pressure_fl: Double?
    open var tpms_pressure_fr: Double?
    open var tpms_pressure_rl: Double?
    open var tpms_pressure_rr: Double?
	
	open var valetMode: Bool?
	open var valetPinNeeded: Bool?
	
	open var vehicleName: String?

    //TOOD: webcam_available: Bool
	
	// MARK: Codable protocol
	
	enum CodingKeys: String, CodingKey {
		case apiVersion				 = "api_version"
		
		case autoparkState			 = "autopark_state"
		case autoparkStateV2		 = "autopark_state_v2"
		case autoparkStyle			 = "autopark_style"
		
		case calendarSupported		 = "calendar_supported"
		
		case firmwareVersion		 = "car_version"
		
		case centerDisplayStateBool		 = "center_display_state"
		
		case driverDoorOpenBool			 = "df"
        case driverWindowOpenBool        = "fd_window"
		case driverRearDoorOpenBool		 = "dr"
        case driverRearWindowOpenBool    = "rd_window"
		case frontTrunkOpenBool			 = "ft"
		
		case homelinkNearby			 = "homelink_nearby"
        case homelinkDeviceCount = "homelink_device_count"
		case isUserPresent 			= "is_user_present"
		
		case lastAutoparkError		 = "last_autopark_error"
		
		case locked					 = "locked"
		case mediaState				= "media_state"
		
		case notificationsSupported	 = "notifications_supported"
		
		case odometer				 = "odometer"
		
		case parsedCalendarSupported = "parsed_calendar_supported"
		
		case passengerDoorOpenBool		 = "pf"
        case passengerWindowOpenBool     = "fp_window"
		case passengerRearDoorOpenBool	 = "pr"
        case passengerRearWindowOpenBool = "rp_window"
		
		case remoteStart			 = "remote_start"
		case remoteStartSupported	 = "remote_start_supported"
		
		case rearTrunkOpenInt			 = "rt"
		
		case sentryMode			= "sentry_mode"
		
        case softwareUpdate         = "software_update"
		case speedLimitMode 		= "speed_limit_mode"

		case sunRoofPercentageOpen	 = "sun_roof_percent_open"
		case sunRoofState			 = "sun_roof_state"
		
		case timeStamp				= "timestamp"
        
        case tpms_pressure_fl = "tpms_pressure_fl"
        case tpms_pressure_fr = "tpms_pressure_fr"
        case tpms_pressure_rl = "tpms_pressure_rl"
        case tpms_pressure_rr = "tpms_pressure_rr"
        
		
		case valetMode				 = "valet_mode"
		case valetPinNeeded			 = "valet_pin_needed"
		
		case vehicleName			 = "vehicle_name"
	}
	
	required public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		apiVersion = try? container.decode(Int.self, forKey: .apiVersion)
		
		autoparkState = try? container.decode(String.self, forKey: .autoparkState)
		autoparkStateV2 = try? container.decode(String.self, forKey: .autoparkStateV2)
		autoparkStyle = try? container.decode(String.self, forKey: .autoparkStyle)
		
		calendarSupported = try? container.decode(Bool.self, forKey: .calendarSupported)
		
		firmwareVersion = try? container.decode(String.self, forKey: .firmwareVersion)
		
		centerDisplayStateBool = try? container.decode(Int.self, forKey: .centerDisplayStateBool)
		
		driverDoorOpenBool = try? container.decode(Int.self, forKey: .driverDoorOpenBool)
        driverWindowOpenBool = try? container.decode(Int.self, forKey: .driverWindowOpenBool)
		driverRearDoorOpenBool = try? container.decode(Int.self, forKey: .driverRearDoorOpenBool)
        driverRearWindowOpenBool = try? container.decode(Int.self, forKey: .driverRearWindowOpenBool)
		
		frontTrunkOpenBool = try? container.decode(Int.self, forKey: .frontTrunkOpenBool)
		
		homelinkNearby = try? container.decode(Bool.self, forKey: .homelinkNearby)
        homelinkDeviceCount = try? container.decode(Int.self, forKey: .homelinkNearby)
		isUserPresent = try? container.decode(Bool.self, forKey: .isUserPresent)
		
		lastAutoparkError = try? container.decode(String.self, forKey: .lastAutoparkError)
		
		locked = try? container.decode(Bool.self, forKey: .locked)
		mediaState = try? container.decode(MediaState.self, forKey: .mediaState)
		
		notificationsSupported = try? container.decode(Bool.self, forKey: .notificationsSupported)
		
		odometer = try? container.decode(Double.self, forKey: .odometer)
		
		parsedCalendarSupported = try? container.decode(Bool.self, forKey: .parsedCalendarSupported)
		
		passengerDoorOpenBool = try? container.decode(Int.self, forKey: .passengerDoorOpenBool)
        passengerWindowOpenBool = try? container.decode(Int.self, forKey: .passengerWindowOpenBool)
		passengerRearDoorOpenBool = try? container.decode(Int.self, forKey: .passengerRearDoorOpenBool)
        passengerRearWindowOpenBool = try? container.decode(Int.self, forKey: .passengerRearWindowOpenBool)
		
		remoteStart = try? container.decode(Bool.self, forKey: .remoteStart)
		remoteStartSupported = try? container.decode(Bool.self, forKey: .remoteStartSupported)
		
		rearTrunkOpenInt = try? container.decode(Int.self, forKey: .rearTrunkOpenInt)

		sentryMode = try? container.decode(Bool.self, forKey: .sentryMode)
		
		softwareUpdate = try? container.decode(SoftwareUpdate.self, forKey: .softwareUpdate)
		speedLimitMode = try? container.decode(SpeedLimitMode.self, forKey: .speedLimitMode)
		sunRoofPercentageOpen = try? container.decode(Int.self, forKey: .sunRoofPercentageOpen)
		sunRoofState = try? container.decode(String.self, forKey: .sunRoofState)
		
		timeStamp = try? container.decode(Double.self, forKey: .timeStamp)
        
        tpms_pressure_fl = try? container.decode(Double.self, forKey: .tpms_pressure_fl)
        tpms_pressure_fr = try? container.decode(Double.self, forKey: .tpms_pressure_fr)
        tpms_pressure_rl = try? container.decode(Double.self, forKey: .tpms_pressure_rl)
        tpms_pressure_rr = try? container.decode(Double.self, forKey: .tpms_pressure_rr)
		
		valetMode = try? container.decode(Bool.self, forKey: .valetMode)
		valetPinNeeded = try? container.decode(Bool.self, forKey: .valetPinNeeded)
		
		vehicleName = try? container.decode(String.self, forKey: .vehicleName)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		try container.encodeIfPresent(apiVersion, forKey: .apiVersion)
		try container.encodeIfPresent(autoparkState, forKey: .autoparkState)
		try container.encodeIfPresent(autoparkStateV2, forKey: .autoparkStateV2)
		try container.encodeIfPresent(autoparkStyle, forKey: .autoparkStyle)
		try container.encodeIfPresent(calendarSupported, forKey: .calendarSupported)
		try container.encodeIfPresent(firmwareVersion, forKey: .firmwareVersion)
		try container.encodeIfPresent(centerDisplayStateBool, forKey: .centerDisplayStateBool)
		try container.encodeIfPresent(driverDoorOpenBool, forKey: .driverDoorOpenBool)
        try container.encodeIfPresent(driverDoorOpenBool, forKey: .driverWindowOpenBool)
		try container.encodeIfPresent(driverRearDoorOpenBool, forKey: .driverRearDoorOpenBool)
        try container.encodeIfPresent(driverRearWindowOpenBool, forKey: .driverRearWindowOpenBool)
		try container.encodeIfPresent(frontTrunkOpenBool, forKey: .frontTrunkOpenBool)
		try container.encodeIfPresent(homelinkNearby, forKey: .homelinkNearby)
        try container.encodeIfPresent(homelinkDeviceCount, forKey: .homelinkDeviceCount)
		try container.encodeIfPresent(isUserPresent, forKey: .isUserPresent)
		try container.encodeIfPresent(lastAutoparkError, forKey: .lastAutoparkError)
		try container.encodeIfPresent(locked, forKey: .locked)
		try container.encodeIfPresent(mediaState, forKey: .mediaState)
		try container.encodeIfPresent(notificationsSupported, forKey: .notificationsSupported)
		try container.encodeIfPresent(odometer, forKey: .odometer)
		try container.encodeIfPresent(parsedCalendarSupported, forKey: .parsedCalendarSupported)
		try container.encodeIfPresent(passengerDoorOpenBool, forKey: .passengerDoorOpenBool)
        try container.encodeIfPresent(passengerWindowOpenBool, forKey: .passengerWindowOpenBool)
		try container.encodeIfPresent(passengerRearDoorOpenBool, forKey: .passengerRearDoorOpenBool)
        try container.encodeIfPresent(passengerRearWindowOpenBool, forKey: .passengerRearWindowOpenBool)
		try container.encodeIfPresent(remoteStart, forKey: .remoteStart)
		try container.encodeIfPresent(remoteStartSupported, forKey: .remoteStartSupported)
		try container.encodeIfPresent(rearTrunkOpenInt, forKey: .rearTrunkOpenInt)
		try container.encodeIfPresent(sentryMode, forKey: .sentryMode)
		try container.encodeIfPresent(softwareUpdate, forKey: .softwareUpdate)
		try container.encodeIfPresent(speedLimitMode, forKey: .speedLimitMode)
		try container.encodeIfPresent(sunRoofPercentageOpen, forKey: .sunRoofPercentageOpen)
		try container.encodeIfPresent(sunRoofState, forKey: .sunRoofState)
		try container.encodeIfPresent(timeStamp, forKey: .timeStamp)
        try container.encodeIfPresent(tpms_pressure_fl, forKey: .tpms_pressure_fl)
        try container.encodeIfPresent(tpms_pressure_fr, forKey: .tpms_pressure_fr)
        try container.encodeIfPresent(tpms_pressure_rl, forKey: .tpms_pressure_rl)
        try container.encodeIfPresent(tpms_pressure_rr, forKey: .tpms_pressure_rr)
		try container.encodeIfPresent(valetMode, forKey: .valetMode)
		try container.encodeIfPresent(valetPinNeeded, forKey: .valetPinNeeded)
		try container.encodeIfPresent(vehicleName, forKey: .vehicleName)
	}
}
