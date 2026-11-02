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
    case appleLogin(AppleLoginRequest)
    case googleLogin(GoogleLoginRequest)
    case refreshToken(RefreshTokenRequest)

    var path: String {
        switch self {
        case .login: "auth/login"
        case .signUp: "auth/signup"
        case .appleLogin: "auth/apple"
        case .googleLogin: "auth/google"
        case .refreshToken: "auth/refresh"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login, .signUp, .appleLogin, .googleLogin, .refreshToken: .post
        }
    }

    var parameters: Parameters? {
        switch self {
        case let .login(username, password):
            ["username": username, "password": password]
        case let .signUp(request):
            request.asParameters
        case let .appleLogin(request):
            request.asParameters
        case let .googleLogin(request):
            request.asParameters
        case let .refreshToken(request):
            request.asParameters
        }
    }

    var requiresAuth: Bool {
        false
    }
}
