//
//  NetworkError.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import Foundation
import Alamofire

enum NetworkError: LocalizedError {
    case noConnection
    case unauthorized
    case server(statusCode: Int)
    case decoding(Error)
    case missingMock(path: String)
    case unknown(Error)

    init(_ error: AFError, statusCode: Int?) {
        if let networkError = error.underlyingError as? NetworkError {
            self = networkError
        } else if let statusCode, !(200..<300).contains(statusCode) {
            // The CDN can drop the connection while sending an error page, so the status code wins.
            self = statusCode == 401 ? .unauthorized : .server(statusCode: statusCode)
        } else if error.isResponseSerializationError {
            self = .decoding(error.underlyingError ?? error)
        } else if let urlError = error.underlyingError as? URLError, Self.connectionErrors.contains(urlError.code) {
            self = .noConnection
        } else {
            self = .unknown(error.underlyingError ?? error)
        }
    }

    var errorDescription: String? {
        switch self {
        case .noConnection:
            "You're offline. Check your connection and try again."
        case .unauthorized:
            "Your session has expired. Please log in again."
        case .server(let statusCode):
            "The server returned an error (\(statusCode))."
        case .decoding:
            "The server sent data the app couldn't read."
        case .missingMock(let path):
            "No mock data for \(path)."
        case .unknown:
            "Something went wrong. Please try again."
        }
    }

    private static let connectionErrors: Set<URLError.Code> = [
        .notConnectedToInternet, .networkConnectionLost, .timedOut,
        .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed
    ]
}
