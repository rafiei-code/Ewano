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
    var page: some View {
        switch self {
        case .home:
            HomeView(user: .sample, userCars: CarModel.samples)
        case .services:
            SchedulePageView(user: .sample, cars: CarModel.samples)
        case .garage:
            GarageView(user: .sample, cars: CarModel.samples)
        case .more:
            ProfilePageView(user: .sample)
        }
    }
}

extension TabItem: Hashable, CaseIterable, Identifiable {
    public var id: Int {
        return rawValue
    }
}
