//
//  Distance.swift
//  Pods
//
//  Created by Jacob Holland on 7/20/17.
//
//

import Foundation

public struct Distance: Codable, Sendable {
    public var value: Measurement<UnitLength>
    
    public init(miles: Double?) {
        let tempValue = miles ?? 0.0
		value = Measurement(value: tempValue, unit: UnitLength.miles)
    }
    public init(kms: Double) {
        value = Measurement(value: kms, unit: UnitLength.kilometers)
    }
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let tempValue = try? container.decode(Double.self) {
			value = Measurement(value: tempValue, unit: UnitLength.miles)
		} else {
			value = Measurement(value: 0, unit: UnitLength.miles)
		}
	}
	
	public func encode(to encoder: Encoder) throws {
		
		var container = encoder.singleValueContainer()
		try container.encode(value.converted(to: .miles).value)
		
	}

	public var miles: Double { return value.converted(to: .miles).value }
	public var kms: Double { return value.converted(to: .kilometers).value }
}
