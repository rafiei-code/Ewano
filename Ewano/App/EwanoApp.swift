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
                StartPageView()
                    .toolbar(.hidden, for: .navigationBar)
                    .appRouteDestinations()
            }
            .environment(\.navigate, NavigateAction { path.append($0) })
            // Pages in one stack share a single color scheme, so it is chosen here from the top page.
            .preferredColorScheme(path.last?.colorScheme ?? .dark)
        }
    }
}
