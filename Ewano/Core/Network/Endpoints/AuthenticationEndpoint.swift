//
//  AuthenticationEndpoint.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import Alamofire

enum AuthenticationEndpoint: Endpoint {
    case login(username: String, password: String)
    case signUp(SignUpRequest)

    var path: String {
        switch self {
        case .login: "auth/login"
        case .signUp: "auth/signup"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login, .signUp: .post
        }
    }

    var parameters: Parameters? {
        switch self {
        case let .login(username, password):
            ["username": username, "password": password]
        case let .signUp(request):
            request.asParameters
        }
    }

    var requiresAuth: Bool {
        false
    }
}
