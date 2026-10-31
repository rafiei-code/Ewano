//
//  Endpoint.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import Alamofire

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
    /// Whether the request carries the logged-in user's token. Defaults to true.
    var requiresAuth: Bool { get }
    /// Bundled JSON file (without extension) that `MockNetworkClient` returns for this endpoint.
    var mockFileName: String? { get }
}

extension Endpoint {
    var method: HTTPMethod { .get }
    var parameters: Parameters? { nil }
    var headers: HTTPHeaders? { nil }
    var requiresAuth: Bool { true }
    var mockFileName: String? { nil }

    var encoding: ParameterEncoding {
        method == .get ? URLEncoding.default : JSONEncoding.default
    }
}
