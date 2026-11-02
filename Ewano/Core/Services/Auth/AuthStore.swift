//
//  AuthStore.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Alamofire
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
        startSession(try await service.login(username: username, password: password))
    }

    /// The backend checks Apple's identity token and answers like a normal login.
    func logInWithApple(_ request: AppleLoginRequest) async throws {
        startSession(try await service.loginWithApple(request))
    }

    /// The backend checks Google's ID token and answers like a normal login.
    func logInWithGoogle(idToken: String) async throws {
        startSession(try await service.loginWithGoogle(GoogleLoginRequest(idToken: idToken)))
    }

    private func startSession(_ response: LoginResponse) {
        let newSession = UserSession(response)
        store.saveSession(newSession)
        AuthInterceptor.shared.credential = newSession
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
        AuthInterceptor.shared.credential = nil
        session = nil
    }

    /// Logs out when the saved refresh token has expired, so the next screen is the start page.
    func dropExpiredSession() {
        guard let session, session.isRefreshTokenExpired else { return }
        logOut()
    }
}
