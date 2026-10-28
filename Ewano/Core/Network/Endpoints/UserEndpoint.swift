//
//  UserEndpoint.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import Alamofire

enum UserEndpoint: Endpoint {
    case currentUser

    var path: String {
        switch self {
        case .currentUser: "users/me"
        }
    }

    var mockFileName: String? {
        switch self {
        case .currentUser: "user_sample"
        }
    }
}
