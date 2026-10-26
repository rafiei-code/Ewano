//
//  EwanoApp.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/24.
//

import SwiftUI

@main
struct EwanoApp: App {
    @State private var path: [AppRoute] = []

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                StartPageView(onLogIn: { path.append(.login) })
                    .toolbar(.hidden, for: .navigationBar)
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .login:
                            LoginPageView()
                        }
                    }
            }
            // Pages in one stack share a single color scheme, so it is chosen here from the top page.
            .preferredColorScheme(path.last?.colorScheme ?? .dark)
        }
    }
}
