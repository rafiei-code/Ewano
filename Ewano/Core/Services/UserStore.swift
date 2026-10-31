//
//  UserStore.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import Foundation
import Observation

@MainActor
final class UserStore: Observable {
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
        self.init(service: Services.shared.login)
    }

    var user: UserModel? {
        if case .loaded(let user) = state { return user }
        return nil
    }

    func load() async {
        state = .loading
        do {
//            state = .loaded(try await service.login(email: "pooyan88", password: "MyPassword123!"))
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
