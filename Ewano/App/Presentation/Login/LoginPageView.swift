//
//  LoginPageView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/26.
//

import SwiftUI

struct LoginPageView: View {
    var onLogIn: (_ email: String, _ password: String) async -> Void = { _, _ in }
    var onAppleSignIn: () -> Void = {}
    var onGoogleSignIn: () -> Void = {}

    @Environment(\.navigate) private var navigate

    @State private var email = ""
    @State private var password = ""
    @State private var isEmailValid = false
    @State private var isPasswordValid = false
    @State private var isLoggingIn = false

    private var canLogIn: Bool {
        isEmailValid && isPasswordValid && !isLoggingIn
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
                    SocialSignInButton(provider: .apple, action: onAppleSignIn)
                    SocialSignInButton(provider: .google, action: onGoogleSignIn)
                }

                footer
                    .padding(.top, 40)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(.svSurfaceHigh)
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
                placeholder: "alex.morgan@email.com",
                text: $email,
                title: "Email address",
                icon: .icMail,
                rules: [
                    .required("Enter your email address"),
                    .email()
                ],
                isEnabled: !isLoggingIn,
                onValidationChange: { isEmailValid = $0 }
            )
            .keyboardType(.emailAddress)
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
                navigate(to: .forgotPassword(email: email.trimmingCharacters(in: .whitespaces)))
            }
                .font(.svBodySm)
                .foregroundStyle(.svOutline)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, -4)

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
            .padding(.top, 4)
        }
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

    private func logIn() {
        isLoggingIn = true
        Task {
            await onLogIn(email.trimmingCharacters(in: .whitespaces), password)
            isLoggingIn = false
        }
    }
}

#Preview {
    NavigationStack {
        LoginPageView()
    }
}
