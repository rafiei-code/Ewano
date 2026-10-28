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
    case server(statusCode: Int)
    case decoding(Error)
    case missingMock(path: String)
    case unknown(Error)

    init(_ error: AFError, statusCode: Int?) {
        if error.isResponseSerializationError {
            self = .decoding(error.underlyingError ?? error)
        } else if let urlError = error.underlyingError as? URLError, Self.connectionErrors.contains(urlError.code) {
            self = .noConnection
        } else if let statusCode {
            self = .server(statusCode: statusCode)
        } else {
            self = .unknown(error.underlyingError ?? error)
        }
    }

    var errorDescription: String? {
        switch self {
        case .noConnection:
            "You're offline. Check your connection and try again."
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
