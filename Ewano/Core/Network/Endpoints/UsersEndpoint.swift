//
//  UsersEndpoint.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Alamofire

enum UsersEndpoint: Endpoint {
    case create(SignUpRequest)
    case list
    case user(id: Int)
    case update(id: Int, request: UpdateUserRequest)
    case delete(id: Int)

    var path: String {
        switch self {
        case .create, .list: "users"
        case let .user(id), let .delete(id), let .update(id, _): "users/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .create: .post
        case .list, .user: .get
        case .update: .patch
        case .delete: .delete
        }
    }

    var parameters: Parameters? {
        switch self {
        case let .create(request): request.asParameters
        case let .update(_, request): request.asParameters
        case .list, .user, .delete: nil
        }
    }

    var requiresAuth: Bool {
        false
    }
}
