//
//  UserProfileEndpoint.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/31.
//

import Alamofire

enum UserProfileEndpoint: Endpoint {
    case userProfile
    case updateProfile(UpdateProfileRequest)
    case updateImage(MultipartPayload)

    var path: String {
        switch self {
        case .userProfile: "profile"
        case .updateProfile: "profile"
        case .updateImage: "profile/image"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .userProfile: .get
        case .updateProfile, .updateImage: .put
        }
    }

    var parameters: Parameters? {
        switch self {
        case .userProfile, .updateImage:
            nil
        case let .updateProfile(request):
            request.asParameters
        }
    }

    var multipart: MultipartPayload? {
        switch self {
        case let .updateImage(payload): payload
        default: nil
        }
    }

    var requiresAuth: Bool {
        true
    }
}

