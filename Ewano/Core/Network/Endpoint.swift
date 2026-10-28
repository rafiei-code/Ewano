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
    /// Bundled JSON file (without extension) that `MockNetworkClient` returns for this endpoint.
    var mockFileName: String? { get }
}

extension Endpoint {
    var method: HTTPMethod { .get }
    var parameters: Parameters? { nil }
    var headers: HTTPHeaders? { nil }
    var mockFileName: String? { nil }

    var encoding: ParameterEncoding {
        method == .get ? URLEncoding.default : JSONEncoding.default
    }
}
