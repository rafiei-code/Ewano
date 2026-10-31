//
//  DataManager.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Foundation

nonisolated final class DataManager: @unchecked Sendable {
    static let shared = DataManager()

    private enum Key {
        static let hasLaunchedBefore = "hasLaunchedBefore"
    }

    private let defaults: UserDefaults
    private let sessionStore: UserSessionStore

    init(defaults: UserDefaults = .standard, sessionStore: UserSessionStore = .shared) {
        self.defaults = defaults
        self.sessionStore = sessionStore
        clearSessionOnFreshInstall()
    }

    var session: UserSession? {
        sessionStore.session
    }

    func saveSession(_ session: UserSession) {
        sessionStore.save(session)
    }

    func clearSession() {
        sessionStore.clear()
    }

    @MainActor
    func logOut() {
        sessionStore.clear()
        UserDataStore.shared.clear()
    }

    // The Keychain survives an uninstall but UserDefaults does not, so a missing flag means a fresh install.
    private func clearSessionOnFreshInstall() {
        guard !defaults.bool(forKey: Key.hasLaunchedBefore) else { return }
        if sessionStore.session != nil {
            sessionStore.clear()
        }
        defaults.set(true, forKey: Key.hasLaunchedBefore)
    }
}
