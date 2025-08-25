//
//  Partner.swift
//  TeslaSwiftDemoTests
//
//  Created by João Nunes on 29/10/2023.
//  Copyright © 2023 Joao Nunes. All rights reserved.
//

import Foundation

public struct PartnerBody: Codable {
    let domain: String
}

public struct PartnerResponse: Codable {
    let response: PartnerResponseBody
}

public struct PartnerResponseBody: Codable {
    let domain: String
    let name: String
    let description: String
    let clientId: String
    let ca: String?
    let createdAt: Date
    let updatedAt: Date
    let enterpriseTier: String
    let publicKey: String

    enum CodingKeys: String, CodingKey {
        case domain
        case name
        case description
        case clientId = "client_id"
        case ca
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case enterpriseTier = "enterprise_tier"
        case publicKey = "public_key"
    }
}
