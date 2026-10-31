//
//  SwitchTabRouter.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 10/28/26.
//

import Combine

final public class SwitchTabRouter: ObservableObject {
    static let shared = SwitchTabRouter()

    @Published var currentTab: TabItem = .home {
        didSet {
            if currentTab == .services, !isShowingSelectedCar {
                selectedCar = nil
            }
        }
    }
    @Published private(set) var selectedCar: CarModel?
    private var isShowingSelectedCar = false

    func select(_ car: CarModel) {
        selectedCar = car
    }

    func showSchedule(for car: CarModel) {
        isShowingSelectedCar = true
        selectedCar = car
        currentTab = .services
        isShowingSelectedCar = false
    }
}
