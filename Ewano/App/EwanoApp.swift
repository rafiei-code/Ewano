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
    @StateObject private var notifications = NotificationManager.shared
    @State private var isShowingSplash = true
    @State private var splashMinimumDuration: Duration = .seconds(3)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        _ = DataManager.shared
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isShowingSplash {
                    SplashPageView(minimumDuration: splashMinimumDuration) {
                        isShowingSplash = false
                        openNotificationsIfRequested()
                    }
                    .transition(.opacity)
                } else {
                    NavigationStack(path: $path) {
                        Group {
                            if let session = authStore.session {
                                signedInContent(for: session)
                            } else {
                                StartPageView()
                            }
                        }
                        .toolbar(.hidden, for: .navigationBar)
                        .appRouteDestinations()
                    }
                    .environment(\.navigate, NavigateAction(action: navigate, popToRoot: { path = [] }))
                    .transition(.opacity)
                }
            }
            .animation(.easeOut(duration: 0.4), value: isShowingSplash)
            .environmentObject(authStore)
            .environmentObject(userData)
            // Logging in or out swaps the root, so drop the pages pushed on top of it.
            .onChange(of: authStore.session?.user) { user in
                path = []
                tabRouter.currentTab = .home
                if user == nil {
                    Task { await notifications.clear() }
                } else {
                    notifications.startNewSession()
                }
                // A fresh login loads the user's data behind the splash.
                if user != nil {
                    splashMinimumDuration = .seconds(1)
                    isShowingSplash = true
                }
            }
            .onChange(of: userData.cars) { cars in
                Task { await notifications.updateBadge(for: cars) }
            }
            .onChange(of: notifications.opensNotificationsPage) { _ in
                openNotificationsIfRequested()
            }
            // Pages in one stack share a single color scheme, so it is chosen here from the top page.
            .preferredColorScheme(isShowingSplash ? .dark : path.last?.colorScheme ?? .light)
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
                action: { isShowingSplash = true }
            )
        case .idle, .loading:
            // Only reached if the splash finished without loading; it loads again.
            Color.svInverseSurface
                .ignoresSafeArea()
                .onAppear { isShowingSplash = true }
        }
    }

    /// A tap on an overdue notification opens the notifications page once the user's cars are on screen.
    private func openNotificationsIfRequested() {
        guard notifications.opensNotificationsPage, !isShowingSplash, authStore.session != nil, userData.phase == .loaded else { return }
        notifications.opensNotificationsPage = false
        path = [.notifications]
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
