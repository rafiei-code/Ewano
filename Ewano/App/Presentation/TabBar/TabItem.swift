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
            HomeView(
                user: .init(
                    id: "1",
                    name: "Ali",
                    email: "ali@gmail.com",
                    password: "1234",
                    profileImageURL: nil,
                    cars: [
                        .init(
                            id: "1",
                            name: "Camry",
                            nickname: "Family car",
                            imageURL: "https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=800",
                            isSelected: false,
                            carManufacturingYears: [],
                            schedules: [
                                .init(id: "1-1", title: "Engine Oil & Filter", accumulatedDistance: 500, serviceInterval: 1_000),
                                .init(id: "1-2", title: "Brake Fluid Flush",   accumulatedDistance: 900, serviceInterval: 1_000),
                                .init(id: "1-3", title: "Cabin Air Filter",     accumulatedDistance: 1_000, serviceInterval: 1_000),
                                .init(id: "1-4", title: "Tire Rotation",        accumulatedDistance: 1_150, serviceInterval: 1_000)
                            ],
                            currentOdometer: "4825"
                        ),
                        .init(
                            id: "2",
                            name: "Corolla",
                            nickname: "Work car",
                            imageURL: "https://images.unsplash.com/photo-1623869675781-80aa31012a5a?w=800",
                            isSelected: false,
                            carManufacturingYears: [],
                            schedules: [
                                .init(id: "2-1", title: "Coolant Change", accumulatedDistance: 300, serviceInterval: 1_000)
                            ],
                            currentOdometer: "12040"
                        )
                    ]
                )
            )
        case .services:
            Color.green.opacity(0.5).ignoresSafeArea()
        case .garage:
            Color.brown.opacity(0.5)
        case .more:
            Color.yellow.opacity(0.5)
        }
    }
}

extension TabItem: Hashable, CaseIterable, Identifiable {
    public var id: Int {
        return rawValue
    }
}
