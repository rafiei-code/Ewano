//
//  LoginPageView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/26.
//

import SwiftUI

struct LoginPageView: View {
    @Environment(\.navigate) private var navigate
    @EnvironmentObject private var authStore: AuthStore

    @State private var username = ""
    @State private var password = ""
    @State private var isUsernameValid = false
    @State private var isPasswordValid = false
    @State private var isLoggingIn = false
    @State private var errorMessage: String?
    @State private var socialProvider: SocialSignInButton.Provider?

    private var canLogIn: Bool {
        isUsernameValid && isPasswordValid && !isLoggingIn && socialProvider == nil
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
//                statusRow
//                    .padding(.top, 12)
//                    .padding(.bottom, 8)

                AuthHeaderView(
                    title: "WELCOME BACK",
                    subtitle: "Log in to track your garage maintenance schedules."
                )
                .padding(.top, 16)
                .padding(.bottom, 28)

//                GarageGlanceCard(
//                    image: .imgLoginFleet,
//                    status: "Active fleet",
//                    detail: "Ready to Sync",
//                    title: "2 Vehicles Monitored",
//                    subtitle: "Next due: Oil & Filter in 420 mi"
//                )
//                .padding(.bottom, 20)

                form

                LabeledDivider(title: "or continue with")
                    .padding(.vertical, 28)

                HStack(spacing: 12) {
                    SocialSignInButton(provider: .apple, isLoading: socialProvider == .apple, action: signInWithApple)
                    SocialSignInButton(provider: .google, isLoading: socialProvider == .google, action: signInWithGoogle)
                }

                footer
                    .padding(.top, 40)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(.svSurfaceHigh)
        .safeAreaInset(edge: .bottom) {
            BottomActionBar(background: .svSurfaceHigh) {
                VStack(spacing: 10) {
                    if let errorMessage {
                        Text(errorMessage)
                            .font(.svBodySm)
                            .foregroundStyle(.svError)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    CustomButtonView(config: .init(
                        title: "LOG IN",
                        isEnabled: canLogIn,
                        isLoading: isLoggingIn,
                        trailingImage: .icArrowForward,
                        trailingImageSize: 20,
                        titleFont: .svButton,
                        titleTracking: 0.85,
                        iconColor: .svOnTertiaryFixed,
                        cornerRadius: 12,
                    ), action: logIn)
                    .shadow(color: .black.opacity(0.12), radius: 4, y: 2)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Login")
                    .font(.svTitle)
                    .foregroundStyle(.svOnSurface)
            }
            .hiddenSharedBackground()
        }
    }

    private var form: some View {
        VStack(spacing: 16) {
            CustomTextFieldView(
                placeholder: "Enter your username",
                text: $username,
                title: "Username",
                icon: .icPerson,
                rules: [.required("Enter your username")],
                isEnabled: !isLoggingIn,
                onValidationChange: { isUsernameValid = $0 }
            )
            .textContentType(.username)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()

            CustomTextFieldView(
                placeholder: "Enter your password",
                text: $password,
                title: "Password",
                icon: .icLock,
                isSecure: true,
                rules: [.required("Enter your password")],
                isEnabled: !isLoggingIn,
                onValidationChange: { isPasswordValid = $0 }
            )

            Button("Forgot password?") {
                navigate(to: .forgotPassword(email: ""))
            }
                .font(.svBodySm)
                .foregroundStyle(.svOutline)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, -4)

        }
        .onChange(of: username) { _ in errorMessage = nil }
        .onChange(of: password) { _ in errorMessage = nil }
    }

    private var footer: some View {
        HStack(spacing: 4) {
            Text("New here?")
                .font(.svBody)
                .foregroundStyle(.svOnSurfaceVariant)
            Button("Create account") { navigate(to: .signUp) }
                .font(.svTitle)
                .foregroundStyle(.svTertiary)
        }
        .frame(maxWidth: .infinity)
    }

    private func signInWithApple() {
        runSocialSignIn(.apple) {
            let request = try await AppleSignIn().signIn()
            try await authStore.logInWithApple(request)
        }
    }

    private func signInWithGoogle() {
        runSocialSignIn(.google) {
            let idToken = try await GoogleSignIn().signIn()
            try await authStore.logInWithGoogle(idToken: idToken)
        }
    }

    // Closing the Apple or Google sheet isn't an error, so it shows nothing.
    private func runSocialSignIn(_ provider: SocialSignInButton.Provider, operation: @escaping () async throws -> Void) {
        guard !isLoggingIn, socialProvider == nil else { return }
        socialProvider = provider
        errorMessage = nil
        Task {
            do {
                try await operation()
            } catch SocialSignInError.canceled {
            } catch NetworkError.server(statusCode: 404) {
                errorMessage = "\(provider.title) sign-in isn't available yet. Please log in with your username."
            } catch NetworkError.unauthorized {
                errorMessage = "\(provider.title) couldn't verify your account. Please try again."
            } catch {
                errorMessage = error.localizedDescription
            }
            socialProvider = nil
        }
    }

    // On success `AuthStore` publishes the session and the app root switches to the tabs.
    private func logIn() {
        isLoggingIn = true
        errorMessage = nil
        Task {
            do {
                try await authStore.logIn(username: username.trimmingCharacters(in: .whitespaces), password: password)
            } catch NetworkError.unauthorized, NetworkError.server(statusCode: 400) {
                errorMessage = "Incorrect username or password."
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoggingIn = false
        }
    }
}

#Preview {
    NavigationStack {
        LoginPageView()
    }
    .environmentObject(AuthStore.shared)
}
