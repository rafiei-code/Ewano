//
//  UsersService.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Foundation

protocol UsersService {
    func create(_ request: SignUpRequest) async throws -> SignUpResponse
    func users() async throws -> [SignUpResponse]
    func user(id: Int) async throws -> SignUpResponse
    func update(id: Int, request: UpdateUserRequest) async throws -> SignUpResponse
    func delete(id: Int) async throws
}

struct UsersServiceImpl: UsersService {
    let client: NetworkProvider<UsersEndpoint>

    func create(_ request: SignUpRequest) async throws -> SignUpResponse {
        try await client.request(.create(request))
    }

    func users() async throws -> [SignUpResponse] {
        try await client.request(.list)
    }

    func user(id: Int) async throws -> SignUpResponse {
        try await client.request(.user(id: id))
    }

    func update(id: Int, request: UpdateUserRequest) async throws -> SignUpResponse {
        try await client.request(.update(id: id, request: request))
    }

    func delete(id: Int) async throws {
        try await client.requestEmpty(.delete(id: id))
    }
}
