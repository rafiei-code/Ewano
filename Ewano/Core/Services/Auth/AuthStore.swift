//
//  AuthStore.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Combine
import Foundation

enum SignUpError: LocalizedError {
    case accountCreatedLoginFailed

    var errorDescription: String? {
        switch self {
        case .accountCreatedLoginFailed:
            "Your account was created, but we couldn't log you in. Please log in."
        }
    }
}

/// Who is logged in. The app shows the start page while `session` is nil and the tabs otherwise.
@MainActor
final class AuthStore: ObservableObject {
    static let shared = AuthStore()

    @Published private(set) var session: UserSession?

    private let service: AuthService
    private let store: DataManager

    init(service: AuthService, store: DataManager = .shared) {
        self.service = service
        self.store = store
        session = store.session
        dropExpiredSession()
    }

    convenience init() {
        self.init(service: Services.shared.auth)
    }

    func logIn(username: String, password: String) async throws {
        let response = try await service.login(username: username, password: password)
        let newSession = UserSession(response)
        store.saveSession(newSession)
        session = newSession
    }

    /// Creates the account, then logs in with the same credentials so the user lands on Home.
    func signUp(_ request: SignUpRequest) async throws {
        _ = try await service.signUp(request)
        do {
            try await logIn(username: request.username, password: request.password)
        } catch {
            throw SignUpError.accountCreatedLoginFailed
        }
    }

    func logOut() {
        store.logOut()
        session = nil
    }

    /// Logs out when the saved token has expired, so the next screen is the start page.
    func dropExpiredSession() {
        guard let session, session.isExpired else { return }
        logOut()
    }
}
