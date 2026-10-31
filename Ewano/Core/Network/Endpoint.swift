//
//  Endpoint.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import Foundation
import Alamofire

struct MultipartPayload {
    let fieldName: String
    let fileName: String
    let mimeType: String
    let data: Data
}

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
    /// Whether the request carries the logged-in user's token. Defaults to true.
    var requiresAuth: Bool { get }
    /// Bundled JSON file (without extension) that `MockNetworkClient` returns for this endpoint.
    var mockFileName: String? { get }
    var multipart: MultipartPayload? { get }
}

extension Endpoint {
    var method: HTTPMethod { .get }
    var parameters: Parameters? { nil }
    var headers: HTTPHeaders? { nil }
    var requiresAuth: Bool { true }
    var mockFileName: String? { nil }
    var multipart: MultipartPayload? { nil }

    var encoding: ParameterEncoding {
        method == .get ? URLEncoding.default : JSONEncoding.default
    }
}

extension Encodable {
    var asParameters: Parameters? {
        guard let data = try? JSONEncoder().encode(self),
              let object = try? JSONSerialization.jsonObject(with: data) as? Parameters else { return nil }
        return object
    }
}
