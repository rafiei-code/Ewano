//
//  SocialLoginRequest.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/11/01.
//

import Foundation

/// Body of `POST auth/apple`. Apple shares the name and email only on the first sign-in, so they're optional.
struct AppleLoginRequest: Encodable {
    let identityToken: String
    let authorizationCode: String
    let fullname: String?
    let email: String?

    enum CodingKeys: String, CodingKey {
        case fullname, email
        case identityToken = "identity_token"
        case authorizationCode = "authorization_code"
    }
}

/// Body of `POST auth/google`.
struct GoogleLoginRequest: Encodable {
    let idToken: String

    enum CodingKeys: String, CodingKey {
        case idToken = "id_token"
    }
}
