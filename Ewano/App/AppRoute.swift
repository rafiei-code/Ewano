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
    case home(user: User, cars: [CarModel])
    case garage(user: User, cars: [CarModel])

    @MainActor @ViewBuilder
    var page: some View {
        switch self {
        case .login: LoginPageView()
        case .signUp: SignUpPageView()
        case .forgotPassword(let email): ForgotPasswordPageView(email: email)
        case .home(let user, let cars): HomeView(user: user, userCars: cars)
        case .garage(let user, let cars): GarageView(user: user, cars: cars)
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
