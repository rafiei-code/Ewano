//
//  UserService.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import Foundation

protocol UserService {
    func login(email: String, password: String) async throws -> LoginResponse
}

struct UserServiceImpl: UserService {
    let client: NetworkProvider<AuthenticationEndpoint>

    func login(email: String, password: String) async throws -> LoginResponse {
        try await client.request(.login(email: email, password: email))
    }
}
