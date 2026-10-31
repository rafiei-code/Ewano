//
//  UserCarsEndpoint.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Alamofire

enum UserCarsEndpoint: Endpoint {
    case userCars

    var path: String {
        switch self {
        case .userCars: "user-cars"
        }
    }
}
