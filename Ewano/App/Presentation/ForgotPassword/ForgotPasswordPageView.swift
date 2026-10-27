//
//  ForgotPasswordPageView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/27.
//

import SwiftUI

struct ForgotPasswordPageView: View {
    let onSendResetLink: (_ email: String) async -> Void

    private static let resendDelay: TimeInterval = 45
    private static let mailAppURL = URL(string: "message://")!

    @Environment(\.openURL) private var openURL

    @State private var email: String
    @State private var isEmailValid = false
    @State private var isSending = false
    @State private var isLinkSent = false
    @State private var resendAvailableAt = Date.distantPast

    init(email: String = "", onSendResetLink: @escaping (_ email: String) async -> Void = { _ in }) {
        _email = State(initialValue: email)
        self.onSendResetLink = onSendResetLink
    }

    private var trimmedEmail: String {
        email.trimmingCharacters(in: .whitespaces)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if isLinkSent {
                    sentState
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                } else {
                    requestState
                        .transition(.opacity.combined(with: .move(edge: .leading)))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 40)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(.svSurfaceHigh)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Forgot Password")
                    .font(.svTitle)
                    .foregroundStyle(.svOnSurface)
            }
        }
    }

    private var requestState: some View {
        VStack(alignment: .leading, spacing: 0) {
            AuthHeaderView(
                title: "FORGOT PASSWORD?",
                subtitle: "Enter the email associated with your Servio account and we'll send you a recovery link."
            )
            .padding(.bottom, 20)

            emailCard
                .padding(.bottom, 16)

            CustomButtonView(config: .init(
                title: "SEND RESET LINK",
                isEnabled: isEmailValid && !isSending,
                isLoading: isSending,
                trailingImage: .icArrowForward,
                trailingImageSize: 20,
                titleColor: .svOnTertiaryContainer,
                titleFont: .svButton,
                titleTracking: 0.85,
                iconColor: .svOnTertiaryContainer,
                cornerRadius: 12,
                backgroundColor: .svTertiaryContainer
            ), action: sendResetLink)
            .shadow(color: .black.opacity(0.08), radius: 2, y: 1)
        }
    }

    private var emailCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            CustomTextFieldView(
                placeholder: "driver@servio.app",
                text: $email,
                appearance: .inset,
                title: "EMAIL ADDRESS",
                icon: .icMail,
                rules: [
                    .required("Enter your email address"),
                    .email()
                ],
                isEnabled: !isSending,
                validatesWhileTyping: true,
                onValidationChange: { isEmailValid = $0 }
            )
            .keyboardType(.emailAddress)
            .textContentType(.username)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .submitLabel(.send)
            .onSubmit {
                if isEmailValid && !isSending { sendResetLink() }
            }

            HStack(spacing: 6) {
                Image(.icVerifiedUserFill)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.svTertiary)
                    .accessibilityHidden(true)
                Text("Encrypted zero-trust link verification")
                    .font(.svBodySm)
                    .foregroundStyle(.svOnSurfaceVariant)
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.svSurfaceLowest)
                .shadow(color: .black.opacity(0.06), radius: 3, y: 2)
        }
    }

    private var sentState: some View {
        VStack(spacing: 16) {
            sentCard

            InfoTipCard(
                icon: .icHelpOutline,
                title: "Check your spam or junk folder",
                subtitle: "If it doesn't arrive within a minute, check that you entered the email you signed up with."
            )
        }
    }

    private var sentCard: some View {
        VStack(spacing: 0) {
            mailBadge
                .padding(.vertical, 12)

            Text("CHECK YOUR EMAIL")
                .font(.svHeadlineMd)
                .foregroundStyle(.svOnSurface)
                .accessibilityAddTraits(.isHeader)

            Text("We sent a password reset link to \(Text(Self.masked(trimmedEmail)).font(.svTitle).foregroundStyle(.svOnSurface))")
                .font(.svBody)
                .foregroundStyle(.svOnSurfaceVariant)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 320)
                .padding(.top, 4)

            InfoTipCard(
                icon: .icSpeed,
                title: "Dispatch Status: Verified",
                subtitle: "Valid for 15 minutes",
                iconColor: .svTertiary,
                badge: "TLS 1.3",
                background: .svSurfaceLow
            )
            .padding(.vertical, 16)

            CustomButtonView(config: .init(
                title: "OPEN EMAIL APP",
                leadingImage: .icOutgoingMail,
                leadingImageSize: 20,
                titleFont: .svButton,
                titleTracking: 0.85,
                iconColor: .svOnTertiaryContainer,
                cornerRadius: 12,
            )) {
                openURL(Self.mailAppURL)
            }

            Button {
                withAnimation(.easeInOut(duration: 0.3)) { isLinkSent = false }
            } label: {
                Text("CHANGE EMAIL ADDRESS")
                    .font(.svButton)
                    .tracking(0.85)
                    .foregroundStyle(.svPrimary)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.pressable)
            .padding(.top, 8)

            resendRow
                .padding(.top, 16)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.svSurfaceLowest)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(.svTertiaryContainer)
                .frame(height: 6)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 6, y: 3)
    }

    private var mailBadge: some View {
        IconCircleView(
            icon: .icMarkEmailRead,
            foreground: .svPrimary,
            background: .svSurfaceHigh,
            diameter: 80,
            iconSize: 38
        )
        .overlay(alignment: .bottomTrailing) {
            IconCircleView(
                icon: .icBuildCircleFill,
                foreground: .svOnTertiaryContainer,
                background: .svTertiaryContainer,
                diameter: 32,
                iconSize: 18
            )
            .offset(x: 4, y: 4)
        }
    }

    private var resendRow: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let secondsLeft = Int(resendAvailableAt.timeIntervalSince(context.date).rounded(.up))

            if secondsLeft > 0 {
                HStack(spacing: 4) {
                    Text("Didn't receive it?")
                        .foregroundStyle(.svOnSurfaceVariant)
                    Text("Resend link in \(Duration.seconds(secondsLeft), format: .time(pattern: .minuteSecond))")
                        .bold()
                        .monospacedDigit()
                        .foregroundStyle(.svOnSurface)
                }
                .font(.svBodySm)
            } else {
                VStack(spacing: 4) {
                    Text("Didn't receive it?")
                        .font(.svBodySm)
                        .foregroundStyle(.svOnSurfaceVariant)
                    Button("Resend link now", action: sendResetLink)
                        .font(.svLabel.bold())
                        .underline()
                        .foregroundStyle(.svPrimary)
                        .disabled(isSending)
                }
            }
        }
    }

    private func sendResetLink() {
        isSending = true
        Task {
            await onSendResetLink(trimmedEmail)
            isSending = false
            resendAvailableAt = .now.addingTimeInterval(Self.resendDelay)
            withAnimation(.easeInOut(duration: 0.3)) { isLinkSent = true }
        }
    }

    private static func masked(_ email: String) -> String {
        guard let at = email.firstIndex(of: "@") else { return email }
        let local = email[..<at]
        let visible = local.prefix(max(1, min(6, local.count - 1)))
        return visible + "***" + email[at...]
    }
}

#Preview {
    NavigationStack {
        ForgotPasswordPageView(email: "alex.morgan@email.com")
    }
}
