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
            self.cars = Self.withCurrentOdometers(loadedCars)
            phase = .loaded
        } catch {
            guard !Task.isCancelled else { return }
            phase = .failed(error.localizedDescription)
        }
    }

    struct ProfileSaveResult {
        var detailsError: Error?
        var photoError: Error?

        var firstError: Error? {
            detailsError ?? photoError
        }
    }

    /// Sends the new details and the new photo at the same time and returns once both requests have finished.
    /// Whichever succeeds is applied to `profile`, even if the other fails.
    func saveProfile(details: UpdateProfileRequest?, photo jpegData: Data?) async -> ProfileSaveResult {
        let service = profileService
        async let detailsResponse = Self.run(details) { try await service.updateProfile($0) }
        async let photoResponse = Self.run(jpegData) {
            try await service.updateImage(MultipartPayload(fieldName: "image", fileName: "profile.jpg", mimeType: "image/jpeg", data: $0))
        }
        let (detailsResult, photoResult) = await (detailsResponse, photoResponse)

        var fullname = profile?.fullname
        var email = profile?.email
        var imageURL = profile?.imageURL
        if case .success(let updated)? = detailsResult {
            fullname = updated.fullname
            email = updated.email
        }
        if case .success(let updated)? = photoResult {
            imageURL = updated.imageURL
        }
        if let fullname {
            profile = ProfileResponse(fullname: fullname, email: email, imageURL: imageURL)
        }

        var result = ProfileSaveResult()
        if case .failure(let error)? = detailsResult { result.detailsError = error }
        if case .failure(let error)? = photoResult { result.photoError = error }
        return result
    }

    private static func run<Input, Output>(_ input: Input?, _ operation: (Input) async throws -> Output) async -> Result<Output, Error>? {
        guard let input else { return nil }
        do {
            return .success(try await operation(input))
        } catch {
            return .failure(error)
        }
    }

    /// Refreshes the cars without leaving the loaded phase, so the screens stay up while it runs.
    func reloadCars() async {
        guard let cars = try? await carsService.cars() else { return }
        self.cars = Self.withCurrentOdometers(cars)
    }

    /// Gives every service its car's current odometer, so progress can count kilometres since the last service.
    private static func withCurrentOdometers(_ cars: [CarModel]) -> [CarModel] {
        cars.map { car in
            let odometer = CarOdometerStore.kilometers(for: car)
            let maintenance = car.maintenance.map { item in
                var item = item
                item.currentOdometerKM = odometer
                return item
            }
            return CarModel(
                id: car.id, userID: car.userID, name: car.name,
                manufacturerID: car.manufacturerID, manufacturer: car.manufacturer,
                modelID: car.modelID, model: car.model, engineID: car.engineID, engine: car.engine,
                imageURL: car.imageURL, imageSourceURL: car.imageSourceURL, maintenance: maintenance
            )
        }
    }

    func clear() {
        profile = nil
        cars = []
        phase = .idle
    }
}
