//
//  AuthService.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Foundation

protocol AuthService {
    func login(username: String, password: String) async throws -> LoginResponse
}

struct AuthServiceImpl: AuthService {
    let client: NetworkProvider<AuthenticationEndpoint>

    func login(username: String, password: String) async throws -> LoginResponse {
        try await client.request(.login(username: username, password: password))
    }
}
