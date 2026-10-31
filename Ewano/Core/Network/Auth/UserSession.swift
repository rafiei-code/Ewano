//
//  UserSession.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Foundation

/// The signed-in user together with the token every authenticated request needs.
nonisolated struct UserSession: Codable, Sendable {
    let user: User
    let token: String
    let tokenType: String
    let expiresAt: Date

    init(_ response: LoginResponse, receivedAt: Date = .now) {
        user = response.user
        token = response.token
        tokenType = response.tokenType
        expiresAt = receivedAt.addingTimeInterval(TimeInterval(response.expiresIn))
    }

    var isExpired: Bool {
        expiresAt <= .now
    }

    var authorizationValue: String {
        "\(tokenType) \(token)"
    }
}
