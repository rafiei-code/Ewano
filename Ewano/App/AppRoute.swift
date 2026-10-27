//
//  AppRoute.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/26.
//

import SwiftUI

enum AppRoute: Hashable {
    case login
    case signUp
    case forgotPassword(email: String)

    @MainActor @ViewBuilder
    var page: some View {
        switch self {
        case .login: LoginPageView()
        case .signUp: SignUpPageView()
        case .forgotPassword(let email): ForgotPasswordPageView(email: email)
        }
    }

    var colorScheme: ColorScheme {
        switch self {
        case .login, .signUp, .forgotPassword: .light
        }
    }
}

struct NavigateAction {
    let action: (AppRoute) -> Void

    func callAsFunction(to route: AppRoute) {
        action(route)
    }
}

extension EnvironmentValues {
    @Entry var navigate = NavigateAction { _ in }
}

extension View {
    func appRouteDestinations() -> some View {
        navigationDestination(for: AppRoute.self) { $0.page }
    }
}
