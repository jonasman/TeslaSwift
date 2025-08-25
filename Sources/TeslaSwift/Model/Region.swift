//
//  Region.swift
//  TeslaSwiftDemoTests
//
//  Created by João Nunes on 29/10/2023.
//  Copyright © 2023 Joao Nunes. All rights reserved.
//

import Foundation

public struct Region: Codable {
    public var region: String
    public var fleetApiBaseUrl: String

    enum CodingKeys: String, CodingKey {
        case region
        case fleetApiBaseUrl = "fleet_api_base_url"
    }
}
