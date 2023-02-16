//
//  AuthToken.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 04/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation

private let oAuthClientID: String = "81527cff06843c8634fdc09e8ac0abefb46ac849f38fe1e431c2ef2106796384"
private let oAuthWebClientID: String = "ownerapi"
private let oAuthClientSecret: String = "c7257eb71a564034f9419ee651c7d0e5f7aa6bfbd18bafb5c5c033b093bb2fa3"
private let oAuthScope: String = "openid email offline_access"
private let oAuthRedirectURI: String = "https://auth.tesla.com/void/callback"

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

class AuthTokenRequest: Encodable {
	
    enum GrantType: String, Encodable {
        case password
        case refreshToken = "refresh_token"
    }
    
    var grantType: GrantType
	var clientID: String = oAuthClientID
	var clientSecret: String = oAuthClientSecret
    
	var email: String?
	var password: String?

    var refreshToken: String?

    init(email: String? = nil, password: String? = nil, grantType: GrantType = .password, refreshToken: String? = nil) {
		self.email = email
		self.password = password
		self.grantType = grantType
        self.refreshToken = refreshToken
	}
	
	// MARK: Codable protocol
	
	enum CodingKeys: String, CodingKey {
		typealias RawValue = String
		
		case grantType = "grant_type"
		case clientID = "client_id"
		case clientSecret = "client_secret"
		case email = "email"
		case password = "password"
        case refreshToken = "refresh_token"
	}
}

class AuthTokenRequestWeb: Encodable {
    enum GrantType: String, Encodable {
        case refreshToken = "refresh_token"
        case authorizationCode = "authorization_code"
    }

    var grantType: GrantType
    var clientID: String = oAuthWebClientID
    var clientSecret: String = oAuthClientSecret

    var codeVerifier: String?
    var code: String?
    var redirectURI: String?

    var refreshToken: String?
    var scope: String?

    init(grantType: GrantType = .authorizationCode, code: String? = nil, codeVerifier: String? = nil, refreshToken: String? = nil) {
        if grantType == .authorizationCode, let codeVerifier {
            self.codeVerifier = codeVerifier
            self.code = code
            redirectURI = oAuthRedirectURI
        } else if grantType == .refreshToken {
            self.refreshToken = refreshToken
            self.scope = oAuthScope
        }
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
    var clientID = oAuthWebClientID
    var clientSecret = oAuthClientSecret
    var redirectURI = oAuthRedirectURI
    var scope = oAuthScope
    let codeChallenge: String
    var codeChallengeMethod = "S256"
    var state = "teslaSwift"

    init(codeChallenge: String) {
        self.codeChallenge = codeChallenge
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
