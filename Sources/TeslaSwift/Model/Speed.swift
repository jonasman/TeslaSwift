//
//  Speed.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 21/03/2020.
//  Copyright © 2020 Joao Nunes. All rights reserved.
//

import Foundation

public struct Speed: Codable, Sendable {
    public var value: Measurement<UnitSpeed>
    
    public init(milesPerHour: Double?) {
        let tempValue = milesPerHour ?? 0.0
        value = Measurement(value: tempValue, unit: UnitSpeed.milesPerHour)
    }
    public init(kilometersPerHour: Double) {
        value = Measurement(value: kilometersPerHour, unit: UnitSpeed.kilometersPerHour)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let tempValue = try? container.decode(Double.self) {
            value = Measurement(value: tempValue, unit: UnitSpeed.milesPerHour)
        } else {
            value = Measurement(value: 0, unit: UnitSpeed.milesPerHour)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(value.converted(to: .milesPerHour).value)
        
    }

    public var milesPerHour: Double { return value.converted(to: .milesPerHour).value }
    public var kilometersPerHour: Double { return value.converted(to: .kilometersPerHour).value }
}
