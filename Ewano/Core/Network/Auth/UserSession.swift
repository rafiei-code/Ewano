//
//  UserSession.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Alamofire
import Foundation

/// The signed-in user together with the tokens every authenticated request needs.
nonisolated struct UserSession: Codable, Sendable, AuthenticationCredential {
    let user: User
    let token: String
    let tokenType: String
    let expiresAt: Date
    let refreshToken: String
    let refreshTokenId: String
    let refreshExpiresAt: Date

    /// Sessions saved before refresh tokens existed have none, so they count as expired and the user logs in again.
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        user = try container.decode(User.self, forKey: .user)
        token = try container.decode(String.self, forKey: .token)
        tokenType = try container.decode(String.self, forKey: .tokenType)
        expiresAt = try container.decode(Date.self, forKey: .expiresAt)
        refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken) ?? ""
        refreshTokenId = try container.decodeIfPresent(String.self, forKey: .refreshTokenId) ?? ""
        refreshExpiresAt = try container.decodeIfPresent(Date.self, forKey: .refreshExpiresAt) ?? .distantPast
    }

    init(_ response: LoginResponse, receivedAt: Date = .now) {
        user = response.user
        token = response.token
        tokenType = response.tokenType
        expiresAt = receivedAt.addingTimeInterval(TimeInterval(response.expiresIn))
        refreshToken = response.refreshToken
        refreshTokenId = response.refreshTokenId
        refreshExpiresAt = receivedAt.addingTimeInterval(TimeInterval(response.refreshExpiresIn))
    }

    init(_ response: RefreshTokenResponse, currentSession: UserSession, receivedAt: Date = .now) {
        user = currentSession.user
        token = response.token
        tokenType = response.tokenType
        expiresAt = receivedAt.addingTimeInterval(TimeInterval(response.expiresIn))
        refreshToken = response.refreshToken
        refreshTokenId = response.refreshTokenId
        refreshExpiresAt = receivedAt.addingTimeInterval(TimeInterval(response.refreshExpiresIn))
    }

    var isExpired: Bool {
        expiresAt <= .now
    }

    var isRefreshTokenExpired: Bool {
        refreshExpiresAt <= .now
    }

    var requiresRefresh: Bool {
        expiresAt.timeIntervalSinceNow <= 5
    }

    var authorizationValue: String {
        "\(tokenType) \(token)"
    }
}
