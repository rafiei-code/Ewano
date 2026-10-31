//
//  TabItem.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 10/28/26.
//

import SwiftUI

public enum TabItem: Int {
    case home
    case services
    case garage
    case more
}

extension TabItem {
    var title: String {
        switch self {
        case .home: return "Home"
        case .services: return "Schedule"
        case .garage: return "Garage"
        case .more: return "Profile"
        }
    }

    var icon: ImageResource {
        switch self {
        case .home: return .icHome
        case .services: return .icCalendarMonth
        case .garage: return .icDirectionsCar
        case .more: return .icPerson
        }
    }

    var iconSize: CGFloat {
        self == .garage ? 26 : 24
    }
    
    @MainActor
    @ViewBuilder
    func page(for user: User, profileResponse: ProfileResponse, userCars: [CarModel]) -> some View {
        switch self {
        case .home:
            HomeView(user: user, userProfile: profileResponse, userCars: userCars)
        case .services:
            SchedulePageView(user: user, userProfile: profileResponse, cars: userCars)
        case .garage:
            GarageView(user: user, userProfile: profileResponse, cars: userCars)
        case .more:
            ProfilePageView(userProfile: profileResponse)
        }
    }
}

extension TabItem: Hashable, CaseIterable, Identifiable {
    public var id: Int {
        return rawValue
    }
}
