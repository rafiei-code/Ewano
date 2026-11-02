//
//  RefreshTokenResponse.swift
//  Ewano
//
//  Created by Abolfazl on 2026/11/2.
//

import Foundation

struct RefreshTokenResponse: Decodable {
    let token: String
    let tokenType: String
    let expiresIn: Int
    let refreshToken: String
    let refreshTokenId: String
    let refreshExpiresIn: Int
}
