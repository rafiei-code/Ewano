//
//  SignUpPageView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/27.
//

import SwiftUI

struct SignUpPageView: View {
    private static let termsURL = URL(string: "servio://terms")!
    private static let privacyURL = URL(string: "servio://privacy")!

    @Environment(\.navigate) private var navigate
    @EnvironmentObject private var authStore: AuthStore

    @State private var name = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isNameValid = false
    @State private var isUsernameValid = false
    @State private var isEmailValid = false
    @State private var isPasswordValid = false
    @State private var isConfirmationValid = false
    @State private var hasAcceptedTerms = false
    @State private var isCreatingAccount = false
    @State private var errorMessage: String?

    private var passwordsMatch: Bool {
        !confirmPassword.isEmpty && confirmPassword == password
    }

    private var canCreateAccount: Bool {
        isNameValid && isUsernameValid && isEmailValid && isPasswordValid && isConfirmationValid
            && hasAcceptedTerms && !isCreatingAccount
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                AuthHeaderView(
                    title: "CREATE ACCOUNT",
                    subtitle: "Start tracking services, warranties, and mileage."
                )
                .padding(.top, 16)
                .padding(.bottom, 20)

                form

                footer
                    .padding(.top, 28)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .scrollDismissesKeyboard(.interactively)
        .animation(.easeOut(duration: 0.2), value: errorMessage)
        .onChange(of: username) { _ in errorMessage = nil }
        .onChange(of: email) { _ in errorMessage = nil }
        .background(.svSurfaceHigh)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Sign Up")
                    .font(.svTitle)
                    .foregroundStyle(.svOnSurface)
            }
        }
    }

    private var form: some View {
        VStack(spacing: 12) {
            CustomTextFieldView(
                placeholder: "Alex Morgan",
                text: $name,
                title: "FULL NAME",
                icon: .icPerson,
                rules: [.required("Enter your full name")],
                isEnabled: !isCreatingAccount,
                onValidationChange: { isNameValid = $0 }
            )
            .textContentType(.name)
            .textInputAutocapitalization(.words)

            CustomTextFieldView(
                placeholder: "alexmorgan",
                text: $username,
                title: "USERNAME",
                icon: .icPerson,
                rules: [
                    .required("Choose a username"),
                    .custom("Usernames can't contain spaces") { !$0.contains(where: \.isWhitespace) }
                ],
                isEnabled: !isCreatingAccount,
                onValidationChange: { isUsernameValid = $0 }
            )
            .textContentType(.username)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()

            CustomTextFieldView(
                placeholder: "alex.morgan@email.com",
                text: $email,
                title: "EMAIL ADDRESS",
                titleAccessory: .icon(.icAlternateEmail),
                icon: .icMail,
                rules: [
                    .required("Enter your email address"),
                    .email()
                ],
                isEnabled: !isCreatingAccount,
                onValidationChange: { isEmailValid = $0 }
            )
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()

            CustomTextFieldView(
                placeholder: "Create a secure password",
                text: $password,
                title: "PASSWORD",
                titleAccessory: .text("Min. 8 chars"),
                icon: .icLock,
                isSecure: true,
                secureContentType: .newPassword,
                rules: [.required("Create a password"), .minLength(8, message: "Use at least 8 characters")],
                isEnabled: !isCreatingAccount,
                onValidationChange: { isPasswordValid = $0 }
            )

            CustomTextFieldView(
                placeholder: "Re-enter password",
                text: $confirmPassword,
                title: "CONFIRM PASSWORD",
                icon: .icLockReset,
                trailingIcon: passwordsMatch ? .icCheckCircle : nil,
                isSecure: true,
                showsRevealButton: false,
                secureContentType: .newPassword,
                rules: [
                    .required("Re-enter your password"),
                    .custom("Passwords don't match") { $0 == password }
                ],
                isEnabled: !isCreatingAccount,
                onValidationChange: { isConfirmationValid = $0 }
            )

            termsRow
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 4)

            if let errorMessage {
                Text(errorMessage)
                    .font(.svBodySm)
                    .foregroundStyle(.svError)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .transition(.opacity)
            }

            CustomButtonView(config: .init(
                title: "CREATE ACCOUNT",
                isEnabled: canCreateAccount,
                isLoading: isCreatingAccount,
                trailingImage: .icArrowForward,
                trailingImageSize: 20,
                titleFont: .svButton,
                titleTracking: 0.85,
                iconColor: .svOnTertiaryContainer,
                cornerRadius: 12,
            ), action: createAccount)
            .shadow(color: .black.opacity(0.12), radius: 4, y: 2)
            .padding(.top, 4)
        }
    }

    private var termsRow: some View {
        HStack(alignment: .top, spacing: 12) {
            CheckboxView(
                isOn: $hasAcceptedTerms,
                accessibilityLabel: "I agree to the Terms of Service and Privacy Policy"
            )
            .padding(.top, 2)

            Text(termsText)
                .font(.svBodySm)
                .foregroundStyle(.svOnSurface)
                .padding(.top, 4)
                .environment(\.openURL, OpenURLAction { url in
                    guard url == Self.termsURL || url == Self.privacyURL else { return .systemAction }
                    navigate(to: .termsPrivacy)
                    return .handled
                })
        }
    }

    private var termsText: AttributedString {
        var text = AttributedString("I agree to the ")
        text.append(termsLink("Terms of Service", url: Self.termsURL))
        text.append(AttributedString(" and "))
        text.append(termsLink("Privacy Policy", url: Self.privacyURL))
        return text
    }

    private func termsLink(_ title: String, url: URL) -> AttributedString {
        var link = AttributedString(title)
        link.link = url
        link.font = .svLabel
        link.foregroundColor = .svTertiary
        link.underlineStyle = Text.LineStyle(pattern: .solid, color: .svTertiaryFixed)
        return link
    }

    private var footer: some View {
        HStack(spacing: 4) {
            Text("Already have an account?")
                .font(.svBody)
                .foregroundStyle(.svOnSurfaceVariant)
            Button {
                navigate(to: .login)
            } label: {
                Text("Log in")
                    .font(.svBody.bold())
                    .foregroundStyle(.svTertiary)
                    .underline(color: .svTertiaryFixed)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func createAccount() {
        let request = SignUpRequest(
            fullname: name.trimmingCharacters(in: .whitespaces),
            username: username,
            password: password,
            email: email.trimmingCharacters(in: .whitespaces)
        )
        isCreatingAccount = true
        errorMessage = nil
        Task {
            do {
                try await authStore.signUp(request)
            } catch NetworkError.server(statusCode: 409) {
                errorMessage = "That username or email is already registered."
            } catch NetworkError.server(statusCode: 400), NetworkError.server(statusCode: 422) {
                errorMessage = "Some details weren't accepted. Check them and try again."
            } catch {
                errorMessage = error.localizedDescription
            }
            isCreatingAccount = false
        }
    }
}

#Preview {
    NavigationStack {
        SignUpPageView()
    }
    .environmentObject(AuthStore.shared)
}
