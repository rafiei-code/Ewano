//
//  SessionAuthenticator.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/11/02.
//

import Alamofire
import Foundation

/// Adds the access token to requests and trades the refresh token for a new session when it stops working.
nonisolated final class SessionAuthenticator: Authenticator {
    func apply(_ credential: UserSession, to urlRequest: inout URLRequest) {
        urlRequest.headers.update(.authorization(credential.authorizationValue))
    }

    func refresh(_ credential: UserSession, for session: Session, completion: @escaping @Sendable (Result<UserSession, any Error>) -> Void) {
        guard !credential.isRefreshTokenExpired else {
            Self.logOut()
            completion(.failure(NetworkError.unauthorized))
            return
        }

        let request = RefreshTokenRequest(refreshToken: credential.refreshToken, refreshTokenId: credential.refreshTokenId)
        Task {
            do {
                let response: RefreshTokenResponse = try await NetworkProvider<AuthenticationEndpoint>().request(.refreshToken(request))
                let newSession = UserSession(response, currentSession: credential)
                DataManager.shared.saveSession(newSession)
                completion(.success(newSession))
            } catch {
                if Self.isRejection(error) {
                    Self.logOut()
                }
                completion(.failure(error))
            }
        }
    }

    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: any Error) -> Bool {
        response.statusCode == 401
    }

    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: UserSession) -> Bool {
        urlRequest.headers["Authorization"] == credential.authorizationValue
    }

    private static func isRejection(_ error: any Error) -> Bool {
        switch error as? NetworkError {
        case .unauthorized, .server(statusCode: 403):
            true
        default:
            false
        }
    }

    private static func logOut() {
        DataManager.shared.clearSession()
        AuthInterceptor.shared.credential = nil
        Task { @MainActor in AuthStore.shared.logOut() }
    }
}
