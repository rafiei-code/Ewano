//
//  AuthenticationEndpoint.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import Alamofire

enum AuthenticationEndpoint: Endpoint {
    case login(username: String, password: String)

    var path: String {
        switch self {
        case .login: "auth/login"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login: .post
        }
    }

    var parameters: Parameters? {
        switch self {
        case let .login(username, password):
            ["username": username, "password": password]
        }
    }

    var requiresAuth: Bool {
        switch self {
        case .login: false
        }
    }
}
