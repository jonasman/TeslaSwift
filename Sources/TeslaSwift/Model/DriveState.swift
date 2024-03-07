//
//  DrivingPosition.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 14/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import CoreLocation

open class DriveState: Codable {
    public enum ShiftState: String, Codable {
        case drive = "D"
        case park = "P"
        case reverse = "R"
        case neutral = "N"
    }
	
	open var shiftState: ShiftState?
	
	open var speed: CLLocationSpeed?
	open var latitude: CLLocationDegrees?
	open var longitude: CLLocationDegrees?
	open var heading: CLLocationDirection?
	open var nativeLatitude: CLLocationDegrees?
	open var nativeLongitude: CLLocationDegrees?
	private var nativeLocationSupportedBool: Int?
	open var nativeLocationSupported: Bool { return nativeLocationSupportedBool == 1 }
	open var nativeType: String?
	
	open var date: Date?
	open var timeStamp: Double?
	open var power: Int?

    open var activeRouteLatitude: CLLocationDegrees?
    open var activeRouteLongitude: CLLocationDegrees?
    open var activeRouteTrafficMinutesDelay: Double?
    open var activeRouteDestination: String?
    open var activeRouteEnergyAtArrival: Int?
    open var activeRouteMilesToArrival: Double?
    open var activeRouteMinutesToArrival: Double?

	open var position: CLLocation? {
		if let latitude = latitude,
			let longitude = longitude,
			let heading = heading,
			let date = date {
				let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
				return CLLocation(coordinate: coordinate,
					altitude: 0.0, horizontalAccuracy: 0.0, verticalAccuracy: 0.0,
					course: heading,
					speed: speed ?? 0,
					timestamp: date)
				
		}
		return nil
	}
	
	enum CodingKeys: String, CodingKey {
		case shiftState	 = "shift_state"
		case speed		 = "speed"
		case latitude	 = "latitude"
		case longitude	 = "longitude"
		case power
		case heading	= "heading"
		case date		= "gps_as_of"
		case timeStamp	= "timestamp"
		case nativeLatitude = "native_latitude"
		case nativeLongitude = "native_longitude"
		case nativeLocationSupportedBool = "native_location_supported"
		case nativeType = "native_type"
        case activeRouteLatitude = "active_route_latitude"
        case activeRouteLongitude = "active_route_longitude"
        case activeRouteTrafficMinutesDelay = "active_route_traffic_minutes_delay"
        case activeRouteDestination = "active_route_destination"
        case activeRouteEnergyAtArrival = "active_route_energy_at_arrival"
        case activeRouteMilesToArrival = "active_route_miles_to_arrival"
        case activeRouteMinutesToArrival = "active_route_minutes_to_arrival"
	}

	required public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
        shiftState = try? container.decode(ShiftState.self, forKey: .shiftState)
		
		speed = try? container.decode(CLLocationSpeed.self, forKey: .speed)
		latitude = try? container.decode(CLLocationDegrees.self, forKey: .latitude)
		longitude = try? container.decode(CLLocationDegrees.self, forKey: .longitude)
		heading = try? container.decode(CLLocationDirection.self, forKey: .heading)
		nativeLatitude = try? container.decode(CLLocationDegrees.self, forKey: .nativeLatitude)
		nativeLongitude = try? container.decode(CLLocationDegrees.self, forKey: .nativeLongitude)
		nativeLocationSupportedBool = try? container.decode(Int.self, forKey: .nativeLocationSupportedBool)

		nativeType = try? container.decode(String.self, forKey: .nativeType)
		
		date = try? container.decode(Date.self, forKey: .date)
		timeStamp = try? container.decode(Double.self, forKey: .timeStamp)
		power = try? container.decode(Int.self, forKey: .power)

        activeRouteLatitude = try? container.decode(CLLocationDegrees.self, forKey: .activeRouteLatitude)
        activeRouteLongitude = try? container.decode(CLLocationDegrees.self, forKey: .activeRouteLongitude)
        activeRouteTrafficMinutesDelay = try? container.decode(Double.self, forKey: .activeRouteTrafficMinutesDelay)
        activeRouteDestination = try? container.decode(String.self, forKey: .activeRouteDestination)
        activeRouteEnergyAtArrival = try? container.decode(Int.self, forKey: .activeRouteEnergyAtArrival)
        activeRouteMilesToArrival = try? container.decode(Double.self, forKey: .activeRouteMilesToArrival)
        activeRouteMinutesToArrival = try? container.decode(Double.self, forKey: .activeRouteMinutesToArrival)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encodeIfPresent(shiftState, forKey: .shiftState)
		
		try container.encodeIfPresent(speed, forKey: .speed)
		try container.encodeIfPresent(latitude, forKey: .latitude)
		try container.encodeIfPresent(longitude, forKey: .longitude)
		try container.encodeIfPresent(heading, forKey: .heading)
		try container.encodeIfPresent(nativeLatitude, forKey: .nativeLatitude)
		try container.encodeIfPresent(nativeLongitude, forKey: .nativeLongitude)
		try container.encodeIfPresent(nativeLocationSupportedBool, forKey: .nativeLocationSupportedBool)

		try container.encodeIfPresent(nativeType, forKey: .nativeType)
		
		try container.encodeIfPresent(date, forKey: .date)
		try container.encodeIfPresent(timeStamp, forKey: .timeStamp)
		try container.encodeIfPresent(power, forKey: .power)

        try container.encodeIfPresent(activeRouteLatitude, forKey: .activeRouteLatitude)
        try container.encodeIfPresent(activeRouteLongitude, forKey: .activeRouteLongitude)
        try container.encodeIfPresent(activeRouteTrafficMinutesDelay, forKey: .activeRouteTrafficMinutesDelay)
        try container.encodeIfPresent(activeRouteDestination, forKey: .activeRouteDestination)
        try container.encodeIfPresent(activeRouteEnergyAtArrival, forKey: .activeRouteEnergyAtArrival)
        try container.encodeIfPresent(activeRouteMilesToArrival, forKey: .activeRouteMilesToArrival)
        try container.encodeIfPresent(activeRouteMinutesToArrival, forKey: .activeRouteMinutesToArrival)
	}
}
