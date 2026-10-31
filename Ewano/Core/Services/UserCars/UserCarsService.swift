//
//  UserCarsService.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Foundation

protocol UserCarsService {
    func cars() async throws -> [CarModel]
}

struct UserCarsServiceImpl: UserCarsService {
    let client: NetworkProvider<UserCarsEndpoint>

    func cars() async throws -> [CarModel] {
        try await client.request(.userCars)
    }
}
