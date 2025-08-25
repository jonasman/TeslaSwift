//
//  StreamEvent.swift
//  TeslaSwift
//
//  Created by Jacob Holland on 4/11/17.
//  Copyright © 2017 Joao Nunes. All rights reserved.
//

import Foundation
import CoreLocation
import TeslaSwift

public enum TeslaStreamingEvent: Equatable {
    case open
    case event(StreamEvent)
    case error(Error)
    case disconnected

    public static func == (lhs: TeslaStreamingEvent, rhs: TeslaStreamingEvent) -> Bool {
        switch (lhs, rhs) {
            case (.open, .open): return true
            case (.event, .event): return true // ignore the event
            case (.error, .error): return true // ignore the error
            case (.disconnected, .disconnected): return true
            default: return false
        }
    }
}

open class StreamEvent: Codable {
    open var timestamp: Double?
    open var speed: CLLocationSpeed? // mph
    open var speedUnit: Speed? {
        guard let speed = speed else { return nil }
        return Speed(milesPerHour: speed)
    }
    open var odometer: Distance? // miles
    open var soc: Int?
    open var elevation: Int? // feet
    open var estLat: CLLocationDegrees?
    open var estLng: CLLocationDegrees?
    open var power: Int? // kW
    open var shiftState: String?
    open var range: Distance? // miles
    open var estRange: Distance? // miles
    open var estHeading: CLLocationDirection?
    open var heading: CLLocationDirection?
	
	open var position: CLLocation? {
		if let latitude = estLat,
			let longitude = estLng,
			let heading = heading,
			let timestamp = timestamp {
			let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
			return CLLocation(coordinate: coordinate,
			                  altitude: 0.0, horizontalAccuracy: 0.0, verticalAccuracy: 0.0,
			                  course: heading,
			                  speed: speed ?? 0,
			                  timestamp: Date(timeIntervalSince1970: timestamp/1000))
		}
		return nil
	}
	
	init(values: String) {
		// timeStamp,speed,odometer,soc,elevation,est_heading,est_lat,est_lng,power,shift_state,range,est_range,heading
		let separatedValues = values.components(separatedBy: ",")
		
		guard separatedValues.count > 11 else { return }
		
		if let timeValue = Double(separatedValues[0]) {
			timestamp = timeValue
		}
		speed = CLLocationSpeed(separatedValues[1])
		if let value = Double(separatedValues[2]) {
			odometer = Distance(miles: value)
		}
		soc = Int(separatedValues[3])
		elevation = Int(separatedValues[4])
		estHeading = CLLocationDirection(separatedValues[5])
		estLat = CLLocationDegrees(separatedValues[6])
		estLng = CLLocationDegrees(separatedValues[7])
		power = Int(separatedValues[8])
		shiftState = separatedValues[9]
		if let value = Double(separatedValues[10]) {
			range = Distance(miles: value)
		}
		if let value = Double(separatedValues[11]) {
			estRange = Distance(miles: value)
		}
		heading = CLLocationDirection(separatedValues[12])
	}
	
	open var originalValues: String {
		var resultString = ""
		if let timestamp = timestamp {
			resultString.append("\(timestamp)")
		}
		resultString.append(",")
		if let speed = speed {
			resultString.append("\(speed)")
		}
		resultString.append(",")
		if let odometer = odometer {
			resultString.append("\(odometer.miles)")
		}
		resultString.append(",")
		if let soc = soc {
			resultString.append("\(soc)")
		}
		resultString.append(",")
		if let elevation = elevation {
			resultString.append("\(elevation)")
		}
		resultString.append(",")
		if let estHeading = estHeading {
			resultString.append("\(estHeading)")
		}
		resultString.append(",")
		if let estLat = estLat {
			resultString.append("\(estLat)")
		}
		resultString.append(",")
		if let estLng = estLng {
			resultString.append("\(estLng)")
		}
		resultString.append(",")
		if let power = power {
			resultString.append("\(power)")
		}
		resultString.append(",")
		if let shiftState = shiftState {
			resultString.append("\(shiftState)")
		}
		resultString.append(",")
		if let range = range {
			resultString.append("\(range.miles)")
		}
		resultString.append(",")
		if let estRange = estRange {
			resultString.append("\(estRange.miles)")
		}
		resultString.append(",")
		if let heading = heading {
			resultString.append("\(heading)")
		}

		return resultString
	}
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case speed
        case odometer
        case soc
        case elevation
        case estLat
        case estLng
        case power
        case shiftState
        case range
        case estRange
        case estHeading
        case heading
    }

}

extension StreamEvent: CustomStringConvertible {
	public var description: String {
        return "speed: \(speed ?? -1), odo: \(odometer?.miles ?? -1.0), soc: \(soc ?? -1), elevation: \(elevation ?? -1), estLat: \(estLat ?? -1), estLng: \(estLng ?? -1), power: \(power ?? -1), shift: \(shiftState ?? ""), range: \(range?.miles ?? -1), estRange: \(estRange?.miles ?? -1) heading: \(heading ?? -1), estHeading: \(estHeading ?? -1), timestamp: \(timestamp ?? 0)"
	}
	
	public var descriptionKm: String {
        return "speed: \(speedUnit?.kilometersPerHour ?? -1), odo: \(odometer?.kms ?? -1.0), soc: \(soc ?? -1), elevation: \(elevation ?? -1), estLat: \(estLat ?? -1), estLng: \(estLng ?? -1), power: \(power ?? -1), shift: \(shiftState ?? ""), range: \(range?.kms ?? -1), estRange: \(estRange?.kms ?? -1) heading: \(heading ?? -1), estHeading: \(estHeading ?? -1), timestamp: \(timestamp ?? 0)"
	}
}
