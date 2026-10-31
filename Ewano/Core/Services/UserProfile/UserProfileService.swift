//
//  UserProfileService.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/31.
//

import Foundation

protocol UserProfileService {
    func profile() async throws -> ProfileResponse
    func updateProfile(_ request: UpdateProfileRequest) async throws -> ProfileResponse
    func updateImage(_ payload: MultipartPayload) async throws -> ProfileResponse
}

struct UserProfileServiceImpl: UserProfileService {
    let client: NetworkProvider<UserProfileEndpoint>

    func profile() async throws -> ProfileResponse {
        try await client.request(.userProfile)
    }

    func updateProfile(_ request: UpdateProfileRequest) async throws -> ProfileResponse {
        try await client.request(.updateProfile(request))
    }

    func updateImage(_ payload: MultipartPayload) async throws -> ProfileResponse {
        try await client.request(.updateImage(payload))
    }
}
