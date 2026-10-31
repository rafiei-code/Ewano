//
//  UserCarsService.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Foundation

protocol UserCarsService {
    func cars() async throws -> [CarModel]
    func createCar(_ request: CreateUserCarRequest) async throws -> MessageResponse
    func saveMaintenance(carID: Int, request: SaveMaintenanceRequest) async throws -> MessageResponse
}

struct UserCarsServiceImpl: UserCarsService {
    let client: NetworkProvider<UserCarsEndpoint>

    func cars() async throws -> [CarModel] {
        try await client.request(.userCars)
    }

    func createCar(_ request: CreateUserCarRequest) async throws -> MessageResponse {
        try await client.request(.createCar(request))
    }

    func saveMaintenance(carID: Int, request: SaveMaintenanceRequest) async throws -> MessageResponse {
        try await client.request(.saveMaintenance(carID: carID, request: request))
    }
}
