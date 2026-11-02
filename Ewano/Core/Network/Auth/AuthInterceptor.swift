//
//  AuthInterceptor.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Alamofire

/// The one interceptor every authenticated request shares, so concurrent 401s trigger a single refresh.
nonisolated enum AuthInterceptor {
    static let shared = AuthenticationInterceptor(
        authenticator: SessionAuthenticator(),
        credential: DataManager.shared.session,
        refreshWindow: .init(interval: 30, maximumAttempts: 2)
    )
}
