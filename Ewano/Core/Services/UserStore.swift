//
//  UserStore.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import Foundation
import Observation

@MainActor
@Observable
final class UserStore {
    enum State {
        case idle
        case loading
        case loaded(UserModel)
        case failed(String)
    }

    private(set) var state: State = .idle
    private let service: UserService

    init(service: UserService) {
        self.service = service
    }

    convenience init() {
        self.init(service: Services.shared.user)
    }

    var user: UserModel? {
        if case .loaded(let user) = state { return user }
        return nil
    }

    func load() async {
        state = .loading
        do {
            state = .loaded(try await service.fetchCurrentUser())
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
