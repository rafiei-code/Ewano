//
//  UserDataStore.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Combine
import Foundation

/// The logged-in user's profile and cars, loaded once per login and shared by every tab.
@MainActor
final class UserDataStore: ObservableObject {
    enum Phase: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    static let shared = UserDataStore()

    @Published private(set) var phase: Phase = .idle
    @Published private(set) var profile: ProfileResponse?
    @Published private(set) var cars: [CarModel] = []

    private let profileService: UserProfileService
    private let carsService: UserCarsService

    init(profileService: UserProfileService, carsService: UserCarsService) {
        self.profileService = profileService
        self.carsService = carsService
    }

    convenience init() {
        self.init(profileService: Services.shared.userProfile, carsService: Services.shared.userCars)
    }

    func load() async {
        clear()
        phase = .loading
        do {
            async let profile = profileService.profile()
            async let cars = carsService.cars()
            let (loadedProfile, loadedCars) = try await (profile, cars)
            guard !Task.isCancelled else { return }
            self.profile = loadedProfile
            self.cars = loadedCars
            phase = .loaded
        } catch {
            guard !Task.isCancelled else { return }
            phase = .failed(error.localizedDescription)
        }
    }

    /// Refreshes the cars without leaving the loaded phase, so the screens stay up while it runs.
    func reloadCars() async {
        guard let cars = try? await carsService.cars() else { return }
        self.cars = cars
    }

    func clear() {
        profile = nil
        cars = []
        phase = .idle
    }
}
