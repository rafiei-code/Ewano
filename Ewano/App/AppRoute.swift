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
    case home(user: UserModel)

    @MainActor @ViewBuilder
    var page: some View {
        switch self {
        case .login: LoginPageView()
        case .signUp: SignUpPageView()
        case .forgotPassword(let email): ForgotPasswordPageView(email: email)
        case .home(let user): HomeView(user: user)
        }
    }

    var colorScheme: ColorScheme {
        switch self {
        default: .light
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
