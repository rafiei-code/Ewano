//
//  UserSessionStore.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Foundation
import Security

/// Keeps the current `UserSession` in the Keychain. Safe to read from any thread.
nonisolated final class UserSessionStore: @unchecked Sendable {
    static let shared = UserSessionStore()

    private let lock = NSLock()
    private var cached: UserSession?
    private let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: Bundle.main.bundleIdentifier ?? "Ewano",
        kSecAttrAccount as String: "userSession"
    ]

    init() {
        cached = loadFromKeychain()
    }

    var session: UserSession? {
        lock.withLock { cached }
    }

    func save(_ session: UserSession) {
        lock.withLock {
            cached = session
            guard let data = try? JSONEncoder().encode(session) else { return }
            SecItemDelete(query as CFDictionary)
            var item = query
            item[kSecValueData as String] = data
            item[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            SecItemAdd(item as CFDictionary, nil)
        }
    }

    func clear() {
        lock.withLock {
            cached = nil
            SecItemDelete(query as CFDictionary)
        }
    }

    private func loadFromKeychain() -> UserSession? {
        var search = query
        search[kSecReturnData as String] = true
        search[kSecMatchLimit as String] = kSecMatchLimitOne
        var result: AnyObject?
        guard SecItemCopyMatching(search as CFDictionary, &result) == errSecSuccess,
              let data = result as? Data else { return nil }
        return try? JSONDecoder().decode(UserSession.self, from: data)
    }
}
