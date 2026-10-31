//
//  UserProfileEndpoint.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/31.
//

import Alamofire

enum UserProfileEndpoint: Endpoint {
    case userProfile

    var path: String {
        switch self {
        case .userProfile: "profile"
        }
    }

    var parameters: Parameters? {
        switch self {
        case .userProfile:
            nil
        }
    }

    var requiresAuth: Bool {
        switch self {
        case .userProfile: true
        }
    }
}

