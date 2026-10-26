//
//  LoginPageView.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI
import Lottie

struct LoginPageView: View {
    var onLogIn: (_ email: String, _ password: String) async -> Void = { _, _ in }
    var onForgotPassword: () -> Void = {}
    var onCreateAccount: () -> Void = {}
    var onAppleSignIn: () -> Void = {}
    var onGoogleSignIn: () -> Void = {}

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
                statusRow
                    .padding(.top, 12)
                    .padding(.bottom, 8)

                header
                    .padding(.top, 16)
                    .padding(.bottom, 28)

                GarageGlanceCard(
                    image: .imgLoginFleet,
                    status: "Active fleet",
                    detail: "Ready to Sync",
                    title: "2 Vehicles Monitored",
                    subtitle: "Next due: Oil & Filter in 420 mi"
                )
                .padding(.bottom, 20)

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
            ToolbarItem(placement: .topBarTrailing) {
                IconCircleView(
                    icon: .icPerson,
                    foreground: .svOnPrimary,
                    background: .svPrimary,
                    diameter: 32,
                    iconSize: 18
                )
            }
            .sharedBackgroundVisibility(.hidden)
        }
    }

    private var statusRow: some View {
        HStack {
            HighlightTag(title: "Servio garage sync", style: .onLight)

            Spacer(minLength: 8)

            HStack(spacing: 4) {
                Image(.icVerifiedUser)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .accessibilityHidden(true)
                Text("SSL 256-bit")
                    .font(.svLabel)
            }
            .foregroundStyle(.svOnSurfaceVariant)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 0) {
                Text("WELCOME BACK")
                    .font(.svHeadlineMobile)
                    .foregroundStyle(.svOnSurface)
                    .accessibilityAddTraits(.isHeader)
                LottieView(animation: .loginStar)
                    .playing(loopMode: .loop)
                    .frame(width: 32, height: 32)
                    .accessibilityHidden(true)
            }

            Text("Log in to track your garage maintenance schedules.")
                .font(.svBody)
                .foregroundStyle(.svOnSurfaceVariant)
                .fixedSize(horizontal: false, vertical: true)
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
                    .custom("Enter a valid email address") {
                        $0.trimmingCharacters(in: .whitespaces).wholeMatch(of: /[^@\s]+@[^@\s]+\.[^@\s]+/) != nil
                    }
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

            Button("Forgot password?", action: onForgotPassword)
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
                titleColor: .svOnTertiaryFixed,
                titleFont: .svButton,
                titleTracking: 0.85,
                iconColor: .svOnTertiaryFixed,
                cornerRadius: 12,
                backgroundColor: .svTertiary
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
            Button("Create account", action: onCreateAccount)
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
