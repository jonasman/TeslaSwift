//
//  AuthToken.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 04/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import CryptoKit

private let oAuthCodeVerifier: String = "81527cff06843c8634fdc09e8ac0abefb46ac849f38fe1e431c2ef21067963841234334232123232323232"

open class AuthToken: Codable {
	
	open var accessToken: String?
	open var tokenType: String?
	open var createdAt: Date? = Date()
	open var expiresIn: TimeInterval?
	open var refreshToken: String?
    open var idToken: String?
	
	open var isValid: Bool {
		if let createdAt = createdAt, let expiresIn = expiresIn {
			return -createdAt.timeIntervalSinceNow < expiresIn
		} else {
			return false
		}
	}
	
	public init(accessToken: String) {
		self.accessToken = accessToken
	}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        accessToken = try? container.decode(String.self, forKey: .accessToken)
        tokenType = try? container.decode(String.self, forKey: .tokenType)
        createdAt = (try? container.decode(Date.self, forKey: .createdAt)) ?? Date()
        expiresIn = try? container.decode(TimeInterval.self, forKey: .expiresIn)
        refreshToken = try? container.decode(String.self, forKey: .refreshToken)
        idToken = try? container.decode(String.self, forKey: .idToken)
    }
	
	// MARK: Codable protocol
	enum CodingKeys: String, CodingKey {
		case accessToken = "access_token"
		case tokenType = "token_type"
        case createdAt = "created_at"
		case expiresIn = "expires_in"
		case refreshToken  = "refresh_token"
        case idToken = "id_token"
	}
}

class AuthTokenRequestWeb: Encodable {

    enum GrantType: String, Encodable {
        case refreshToken = "refresh_token"
        case authorizationCode = "authorization_code"
        case clientCredentials = "client_credentials"
    }

    var grantType: GrantType
    var clientID: String
    var clientSecret: String

    var codeVerifier: String?
    var code: String?
    var redirectURI: String?

    var refreshToken: String?
    var scope: String?
    var audience: String?

    init(teslaAPI: TeslaAPI, grantType: GrantType = .authorizationCode, code: String? = nil, refreshToken: String? = nil) {
        switch grantType {
            case .authorizationCode:
                self.codeVerifier = oAuthCodeVerifier
                self.redirectURI = teslaAPI.redirectURI
                self.audience = teslaAPI.region?.rawValue
                self.code = code
            case .refreshToken:
                self.refreshToken = refreshToken
                self.scope = teslaAPI.scope
            case .clientCredentials:
                self.scope = teslaAPI.scope
                self.audience = teslaAPI.region?.rawValue
        }
        self.clientID = teslaAPI.clientID
        self.clientSecret = teslaAPI.clientSecret
        self.grantType = grantType
    }

    // MARK: Codable protocol
    enum CodingKeys: String, CodingKey {
        typealias RawValue = String

        case grantType = "grant_type"
        case clientID = "client_id"
        case clientSecret = "client_secret"
        case code = "code"
        case redirectURI = "redirect_uri"
        case refreshToken = "refresh_token"
        case codeVerifier = "code_verifier"
        case scope = "scope"
    }
}

class AuthCodeRequest: Encodable {

    var responseType: String = "code"
    var clientID: String
    var clientSecret: String
    var redirectURI: String
    var scope: String
    let codeChallenge: String
    var codeChallengeMethod = "S256"
    var state = "teslaSwift"

    init(teslaAPI: TeslaAPI) {
        self.clientID = teslaAPI.clientID
        self.clientSecret = teslaAPI.clientSecret
        self.redirectURI = teslaAPI.redirectURI
        self.scope = teslaAPI.scope
        self.codeChallenge = oAuthCodeVerifier.challenge
    }

    // MARK: Codable protocol
    enum CodingKeys: String, CodingKey {
        typealias RawValue = String

        case clientID = "client_id"
        case redirectURI = "redirect_uri"
        case responseType = "response_type"
        case scope = "scope"
        case codeChallenge = "code_challenge"
        case codeChallengeMethod = "code_challenge_method"
        case state = "state"
    }

    func parameters() -> [URLQueryItem] {
        return[
            URLQueryItem(name: CodingKeys.clientID.rawValue, value: clientID),
            URLQueryItem(name: CodingKeys.redirectURI.rawValue, value: redirectURI),
            URLQueryItem(name: CodingKeys.responseType.rawValue, value: responseType),
            URLQueryItem(name: CodingKeys.scope.rawValue, value: scope),
            URLQueryItem(name: CodingKeys.codeChallenge.rawValue, value: codeChallenge),
            URLQueryItem(name: CodingKeys.codeChallengeMethod.rawValue, value: codeChallengeMethod),
            URLQueryItem(name: CodingKeys.state.rawValue, value: state)
        ]
    }
}

extension String {
    var challenge: String {
        let hash = self.sha256
        let challenge = hash.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
        return challenge
    }

    private var sha256: Data {
        let inputData = Data(self.utf8)
        let hashed = SHA256.hash(data: inputData)
        return Data(hashed)
    }
}

extension TeslaAPI {
    var region: Region? {
        switch self {
            case .ownerAPI: return nil
        case let .fleetAPI(region: region, clientID: _, clientSecret: _, redirectURI: _, scopes: _): return region
        }
    }

    var clientID: String {
        switch self {
            case .ownerAPI: return "ownerapi"
            case let .fleetAPI(region: _, clientID: clientID, clientSecret: _, redirectURI: _, scopes: _): return clientID
        }
    }

    var clientSecret: String {
        switch self {
            case .ownerAPI: return "c7257eb71a564034f9419ee651c7d0e5f7aa6bfbd18bafb5c5c033b093bb2fa3"
            case let .fleetAPI(region: _, clientID: _, clientSecret: clientSecret, redirectURI: _, scopes: _): return clientSecret
        }
    }

    var redirectURI: String {
        switch self {
            case .ownerAPI: return "https://auth.tesla.com/void/callback"
            case let .fleetAPI(region: _, clientID: _, clientSecret: _, redirectURI: redirectURI, scopes: _): return redirectURI
        }
    }

    var scope: String {
        switch self {
            case .ownerAPI: return "openid email offline_access"
            case let .fleetAPI(region: _, clientID: _, clientSecret: _, redirectURI: _, scopes: scopes):
            return scopes.map { $0.rawValue }.joined(separator: " ")
        }
    }
}
