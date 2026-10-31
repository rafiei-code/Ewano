//
//  UserEndpoint.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import Alamofire
import Foundation

enum AuthenticationEndpoint: Endpoint {
    case login(email: String, password: String)



    var path: String {
        switch self {
        case .login: "/auth/login"
        }
    }

    var body: Data? {
        switch self {
        case let .login(username, password):
            return try? JSONEncoder().encode(LoginModel(username: "testuser1", password: "Test@12345"))
        }
    }
}
