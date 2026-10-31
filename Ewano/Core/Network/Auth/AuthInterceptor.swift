//
//  AuthInterceptor.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Alamofire
import Foundation

/// Adds the stored token to authenticated requests and logs the user out when the server rejects it.
nonisolated struct AuthInterceptor: RequestInterceptor {
    var store: UserSessionStore = .shared

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping @Sendable (Result<URLRequest, any Error>) -> Void) {
        guard let userSession = store.session, !userSession.isExpired else {
            Self.logOut()
            completion(.failure(NetworkError.unauthorized))
            return
        }
        var request = urlRequest
        request.headers.add(.authorization(userSession.authorizationValue))
        completion(.success(request))
    }

    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping @Sendable (RetryResult) -> Void) {
        if request.response?.statusCode == 401 {
            Self.logOut()
        }
        completion(.doNotRetry)
    }

    private static func logOut() {
        Task { @MainActor in AuthStore.shared.logOut() }
    }
}
