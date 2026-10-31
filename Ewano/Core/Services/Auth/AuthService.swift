//
//  AuthService.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Foundation

protocol AuthService {
    func login(username: String, password: String) async throws -> LoginResponse
    func signUp(_ request: SignUpRequest) async throws -> SignUpResponse
}

struct AuthServiceImpl: AuthService {
    let client: NetworkProvider<AuthenticationEndpoint>

    func login(username: String, password: String) async throws -> LoginResponse {
        try await client.request(.login(username: username, password: password))
    }

    func signUp(_ request: SignUpRequest) async throws -> SignUpResponse {
        try await client.request(.signUp(request))
    }
}
