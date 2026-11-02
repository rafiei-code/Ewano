//
//  RefreshTokenRequest.swift
//  Ewano
//
//  Created by Abolfazl on 2026/11/2.
//

import Foundation

struct RefreshTokenRequest: Encodable {
    let refreshToken: String
    let refreshTokenId: String
}
