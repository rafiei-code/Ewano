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
    @StateObject private var authStore = AuthStore.shared
    @StateObject private var userData = UserDataStore.shared

    init() {
        _ = DataManager.shared
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                Group {
                    if let session = authStore.session {
                        signedInContent(for: session)
                    } else {
                        StartPageView()
                    }
                }
                .task(id: authStore.session?.user.id) {
                    if authStore.session == nil {
                        userData.clear()
                    } else {
                        await userData.load()
                    }
                }
                .toolbar(.hidden, for: .navigationBar)
                .appRouteDestinations()
            }
            .environment(\.navigate, NavigateAction(action: navigate))
            .environmentObject(authStore)
            // Logging in or out swaps the root, so drop the pages pushed on top of it.
            .onChange(of: authStore.session?.user) { _ in
                path = []
                tabRouter.currentTab = .home
            }
            // Pages in one stack share a single color scheme, so it is chosen here from the top page.
            .preferredColorScheme(path.last?.colorScheme ?? .light)
        }
    }

    @ViewBuilder
    private func signedInContent(for session: UserSession) -> some View {
        switch userData.phase {
        case .loaded:
            if let profile = userData.profile {
                TabBarView(router: tabRouter, user: session.user, userProfile: profile, userCars: userData.cars)
            }
        case .failed(let message):
            StateMessageView(
                kind: .error,
                icon: .icWarningFill,
                title: "Something went wrong",
                message: message,
                actionTitle: "Retry",
                action: { Task { await userData.load() } }
            )
        case .idle, .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
