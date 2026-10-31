//
//  AuthStore.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Combine
import Foundation

/// Who is logged in. The app shows the start page while `session` is nil and the tabs otherwise.
@MainActor
final class AuthStore: ObservableObject {
    static let shared = AuthStore()

    @Published private(set) var session: UserSession?

    private let service: AuthService
    private let store: UserSessionStore

    init(service: AuthService, store: UserSessionStore = .shared) {
        self.service = service
        self.store = store
        if let saved = store.session, !saved.isExpired {
            session = saved
        } else {
            store.clear()
        }
    }

    convenience init() {
        self.init(service: Services.shared.auth)
    }

    func logIn(username: String, password: String) async throws {
        let response = try await service.login(username: username, password: password)
        let newSession = UserSession(response)
        store.save(newSession)
        session = newSession
    }

    func logOut() {
        store.clear()
        session = nil
    }
}
