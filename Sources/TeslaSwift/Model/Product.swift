//
//  Product.swift
//  TeslaSwift
//
//  Created by Alec on 11/23/21.
//  Copyright © 2021 Joao Nunes. All rights reserved.
//

import Foundation

final public class Product: Codable, Sendable {
    public let vehicle: Vehicle?
    public let energySite: EnergySite?

    public var isValidProduct: Bool { vehicle != nil || energySite != nil}
    
    required public init(from decoder: Decoder) throws {
        let vehicleContainer = try decoder.container(keyedBy: Vehicle.CodingKeys.self)
        let energySiteContainer = try decoder.container(keyedBy: EnergySite.CodingKeys.self)
        
        if vehicleContainer.contains(Vehicle.CodingKeys.vehicleID) {
            self.vehicle = try Vehicle(from: decoder)
            self.energySite = nil
        } else if energySiteContainer.contains(EnergySite.CodingKeys.energySiteID) {
            self.vehicle = nil
            self.energySite = try EnergySite(from: decoder)
        } else {
            self.vehicle = nil
            self.energySite = nil
        }
    }
}
