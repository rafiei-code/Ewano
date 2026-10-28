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
    @State private var tabRouter = SwitchTabRouter.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                TabBarView(router: tabRouter)
                    .toolbar(.hidden, for: .navigationBar)
                    .appRouteDestinations()
            }
            .environment(\.navigate, NavigateAction(action: navigate))
            // Pages in one stack share a single color scheme, so it is chosen here from the top page.
            .preferredColorScheme(path.last?.colorScheme ?? .dark)
        }
    }

    // Going to a page that is already in the stack pops back to it, so Login ⇄ Sign Up never piles up copies.
    private func navigate(to route: AppRoute) {
        if let index = path.firstIndex(of: route) {
            path.removeSubrange((index + 1)...)
        } else {
            path.append(route)
        }
    }
}
