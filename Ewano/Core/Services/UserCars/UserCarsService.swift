//
//  UserCarsService.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Foundation

protocol UserCarsService {
    func cars() async throws -> [CarModel]
    func createCar(_ request: CreateUserCarRequest) async throws -> CarModel
    func saveMaintenance(carID: Int, request: SaveMaintenanceRequest) async throws
}

enum UserCarsError: LocalizedError {
    case newCarNotFound

    var errorDescription: String? {
        switch self {
        case .newCarNotFound:
            "Your car was added, but it couldn't be loaded. Check your garage and try again."
        }
    }
}

struct UserCarsServiceImpl: UserCarsService {
    let client: NetworkProvider<UserCarsEndpoint>

    func cars() async throws -> [CarModel] {
        try await client.request(.userCars)
    }

    func createCar(_ request: CreateUserCarRequest) async throws -> CarModel {
        let _: MessageResponse = try await client.request(.createCar(request))

        // The create call only answers {"message": "success"}, so the new car is the newest one matching the request.
        let newCar = try await cars()
            .filter { $0.name == request.name && $0.modelID == request.modelID && $0.engineID == request.engineID }
            .max { $0.id < $1.id }
        guard let newCar else { throw UserCarsError.newCarNotFound }
        return newCar
    }

    func saveMaintenance(carID: Int, request: SaveMaintenanceRequest) async throws {
        try await client.requestEmpty(.saveMaintenance(carID: carID, request: request))
    }
}
