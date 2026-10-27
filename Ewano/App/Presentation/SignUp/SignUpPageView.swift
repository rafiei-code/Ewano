//
//  SignUpPageView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/27.
//

import SwiftUI

struct SignUpPageView: View {
    var onCreateAccount: (_ name: String, _ email: String, _ password: String) async -> Void = { _, _, _ in }
    var onTermsOfService: () -> Void = {}
    var onPrivacyPolicy: () -> Void = {}

    private static let termsURL = URL(string: "servio://terms")!
    private static let privacyURL = URL(string: "servio://privacy")!

    @Environment(\.navigate) private var navigate

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isNameValid = false
    @State private var isEmailValid = false
    @State private var isPasswordValid = false
    @State private var isConfirmationValid = false
    @State private var hasAcceptedTerms = false
    @State private var isCreatingAccount = false

    private var passwordsMatch: Bool {
        !confirmPassword.isEmpty && confirmPassword == password
    }

    private var canCreateAccount: Bool {
        isNameValid && isEmailValid && isPasswordValid && isConfirmationValid
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
            .textContentType(.username)
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
                    switch url {
                    case Self.termsURL: onTermsOfService()
                    case Self.privacyURL: onPrivacyPolicy()
                    default: return .systemAction
                    }
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
        isCreatingAccount = true
        Task {
            await onCreateAccount(
                name.trimmingCharacters(in: .whitespaces),
                email.trimmingCharacters(in: .whitespaces),
                password
            )
            isCreatingAccount = false
        }
    }
}

#Preview {
    NavigationStack {
        SignUpPageView()
    }
}
