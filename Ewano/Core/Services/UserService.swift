//
//  UserService.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import Foundation

protocol UserService {
    func fetchCurrentUser() async throws -> UserModel
}

struct UserServiceImpl: UserService {
    let client: NetworkProvider<UserEndpoint>
    
    func fetchCurrentUser() async throws -> UserModel {
        try await client.request(.currentUser)
    }
}
