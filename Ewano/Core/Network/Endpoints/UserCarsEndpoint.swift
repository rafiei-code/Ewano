//
//  UserCarsEndpoint.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Alamofire

enum UserCarsEndpoint: Endpoint {
    case userCars
    case createCar(CreateUserCarRequest)
    case saveMaintenance(carID: Int, request: SaveMaintenanceRequest)

    var path: String {
        switch self {
        case .userCars: "user-cars"
        case .createCar: "user-cars"
        case let .saveMaintenance(carID, _): "user-cars/\(carID)/maintenance"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .userCars: .get
        case .createCar, .saveMaintenance: .post
        }
    }

    var parameters: Parameters? {
        switch self {
        case .userCars: nil
        case let .createCar(request): request.asParameters
        case let .saveMaintenance(_, request): request.asParameters
        }
    }
}
