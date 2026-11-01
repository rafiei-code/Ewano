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
    case selectManufacturer
    case selectCarModel(manufacturer: Manufacturer)
    case selectEngine(manufacturer: Manufacturer, model: ManufacturerModel)
    case maintenanceSetup(NewCarSelection, car: CarModel)
    case aboutUs
    case helpCenter
    case termsPrivacy
    case editProfile
    case notifications
    case editMaintenance(car: CarModel)

    @MainActor @ViewBuilder
    var page: some View {
        switch self {
        case .login: LoginPageView()
        case .signUp: SignUpPageView()
        case .forgotPassword(let email): ForgotPasswordPageView(email: email)
        case .home(let user, let cars): HomeView(user: user, userProfile: .sample, userCars: cars)
        case .garage(let user, let cars): GarageView(user: user, userProfile: .sample, cars: cars)
        case .selectManufacturer: SelectManufacturerPageView()
        case .selectCarModel(let manufacturer): SelectCarModelPageView(manufacturer: manufacturer)
        case .selectEngine(let manufacturer, let model): SelectEnginePageView(manufacturer: manufacturer, model: model)
        case .maintenanceSetup(let selection, let car): MaintenancePageView(selection: selection, car: car)
        case .aboutUs: AboutUsPageView()
        case .helpCenter: HelpCenterPageView()
        case .termsPrivacy: TermsPrivacyPageView()
        case .editProfile: EditProfilePageView()
        case .notifications: NotificationsPageView()
        case .editMaintenance(let car): MaintenancePageView(car: car)
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
    var popToRoot: () -> Void = {}

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
