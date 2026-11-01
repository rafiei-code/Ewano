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
    func loginWithApple(_ request: AppleLoginRequest) async throws -> LoginResponse
    func loginWithGoogle(_ request: GoogleLoginRequest) async throws -> LoginResponse
}

struct AuthServiceImpl: AuthService {
    let client: NetworkProvider<AuthenticationEndpoint>

    func login(username: String, password: String) async throws -> LoginResponse {
        try await client.request(.login(username: username, password: password))
    }

    func signUp(_ request: SignUpRequest) async throws -> SignUpResponse {
        try await client.request(.signUp(request))
    }

    func loginWithApple(_ request: AppleLoginRequest) async throws -> LoginResponse {
        try await client.request(.appleLogin(request))
    }

    func loginWithGoogle(_ request: GoogleLoginRequest) async throws -> LoginResponse {
        try await client.request(.googleLogin(request))
    }
}
