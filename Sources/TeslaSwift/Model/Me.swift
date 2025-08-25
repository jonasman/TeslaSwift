//
//  Me.swift
//  TeslaSwiftDemoTests
//
//  Created by João Nunes on 29/10/2023.
//  Copyright © 2023 Joao Nunes. All rights reserved.
//

import Foundation

public struct Me: Codable {
    public var email: String
    public var fullName: String
    public var profileImageUrl: String

    enum CodingKeys: String, CodingKey {
        case email
        case fullName = "full_name"
        case profileImageUrl = "profile_image_url"
    }
}
