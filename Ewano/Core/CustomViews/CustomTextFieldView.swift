//
//  CustomTextFieldView.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI

struct TextFieldRule {
    let message: String
    let isValid: (String) -> Bool

    static func required(_ message: String = "This field is required") -> TextFieldRule {
        TextFieldRule(message: message) { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }

    static func minLength(_ length: Int, message: String? = nil) -> TextFieldRule {
        TextFieldRule(message: message ?? "Must be at least \(length) characters") { $0.count >= length }
    }

    static func maxLength(_ length: Int, message: String? = nil) -> TextFieldRule {
        TextFieldRule(message: message ?? "Must be at most \(length) characters") { $0.count <= length }
    }

    static func containsDigit(_ message: String = "Must contain a number") -> TextFieldRule {
        TextFieldRule(message: message) { $0.contains(where: \.isNumber) }
    }

    static func containsLetter(_ message: String = "Must contain a letter") -> TextFieldRule {
        TextFieldRule(message: message) { $0.contains(where: \.isLetter) }
    }

    static func email(_ message: String = "Enter a valid email address") -> TextFieldRule {
        TextFieldRule(message: message) {
            $0.trimmingCharacters(in: .whitespaces)
                .wholeMatch(of: /[A-Za-z0-9._%+\-]+@[A-Za-z0-9\-]+(\.[A-Za-z0-9\-]+)*\.[A-Za-z]{2,}/) != nil
        }
    }

    static func custom(_ message: String, isValid: @escaping (String) -> Bool) -> TextFieldRule {
        TextFieldRule(message: message, isValid: isValid)
    }
}

struct CustomTextFieldView: View {
    enum TitleAccessory {
        case text(String)
        case icon(ImageResource)
    }

    enum Appearance {
        case card
        case inset
    }

    let placeholder: String
    @Binding var text: String
    var appearance: Appearance = .card
    var title: String?
    var titleAccessory: TitleAccessory?
    var icon: ImageResource?
    var trailingIcon: ImageResource?
    var isSecure: Bool = false
    var showsRevealButton: Bool = true
    var secureContentType: UITextContentType = .password
    var rules: [TextFieldRule] = []
    var isEnabled: Bool = true
    var validatesWhileTyping: Bool = false
    var onValidationChange: ((Bool) -> Void)?

    @FocusState private var isFocused: Bool
    @State private var isRevealed = false
    @State private var hasInteracted = false

    private var failingMessage: String? {
        rules.first { !$0.isValid(text) }?.message
    }

    private var errorMessage: String? {
        hasInteracted ? failingMessage : nil
    }

    private var hasError: Bool {
        errorMessage != nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            fieldContainer
                .opacity(isEnabled ? 1 : 0.5)
                .onTapGesture { isFocused = true }

            if let errorMessage {
                HStack(spacing: 6) {
                    Image(.icWarningFill)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                        .accessibilityHidden(true)
                    Text(errorMessage)
                        .font(.svLabel)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .foregroundStyle(.svError)
                .padding(.horizontal, 4)
                .transition(.opacity.combined(with: .move(edge: .top)))
                .accessibilityElement(children: .combine)
            }
        }
        .animation(.easeOut(duration: 0.15), value: isFocused)
        .animation(.easeOut(duration: 0.15), value: errorMessage)
        .onChange(of: isFocused) { _, focused in
            if !focused { hasInteracted = true }
        }
        .onAppear {
            if !text.isEmpty { hasInteracted = true }
        }
        .onChange(of: text) {
            if validatesWhileTyping { hasInteracted = true }
        }
        .onChange(of: failingMessage == nil, initial: true) { _, isValid in
            onValidationChange?(isValid)
        }
    }

    @ViewBuilder
    private var fieldContainer: some View {
        switch appearance {
        case .card:
            VStack(alignment: .leading, spacing: 0) {
                titleRow
                inputRow
            }
            .padding(.horizontal, 16)
            .padding(.top, title == nil ? 0 : 12)
            .cardSurface(cornerRadius: 16, hasShadow: false)
        case .inset:
            VStack(alignment: .leading, spacing: 8) {
                titleRow
                inputRow
                    .padding(.horizontal, 12)
                    .frame(minHeight: 56)
                    .background(Color.svSurfaceLow, in: RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    @ViewBuilder
    private var titleRow: some View {
        if let title {
            HStack(spacing: 8) {
                Text(title)
                    .font(.svLabel)
                    .foregroundStyle(hasError ? .svError : .svOnSurfaceVariant)
                    .accessibilityHidden(true)

                if let titleAccessory {
                    Spacer(minLength: 0)
                    titleAccessoryView(titleAccessory)
                }
            }
        }
    }

    private var inputRow: some View {
        HStack(spacing: 12) {
            if let icon {
                Image(icon)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .foregroundStyle(hasError ? .svError : .svOnSurfaceVariant)
                    .accessibilityHidden(true)
            }

            field
                .font(.svBody)
                .foregroundStyle(.svOnSurface)
                .focused($isFocused)
                .disabled(!isEnabled)
                .frame(minHeight: 44)
                .accessibilityLabel(title ?? placeholder)

            if let trailingIcon {
                Image(trailingIcon)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.svTertiary)
                    .transition(.scale.combined(with: .opacity))
                    .accessibilityHidden(true)
            }

            if isSecure && showsRevealButton {
                revealButton
            }
        }
        .animation(.spring(duration: 0.25), value: trailingIcon)
    }

    @ViewBuilder
    private func titleAccessoryView(_ accessory: TitleAccessory) -> some View {
        switch accessory {
        case .text(let value):
            Text(value)
                .font(.svLabel)
                .foregroundStyle(.svOutline)
        case .icon(let resource):
            Image(resource)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 18, height: 18)
                .foregroundStyle(.svOutlineVariant)
                .accessibilityHidden(true)
        }
    }

    @ViewBuilder
    private var field: some View {
        if isSecure && !isRevealed {
            SecureField(placeholder, text: $text)
                .textContentType(secureContentType)
        } else {
            TextField(placeholder, text: $text)
                .autocorrectionDisabled(isSecure)
                .textInputAutocapitalization(isSecure ? .never : nil)
        }
    }

    private var revealButton: some View {
        Button {
            isRevealed.toggle()
        } label: {
            Image(.icVisibility)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundStyle(.svOnSurfaceVariant)
                .overlay {
                    if isRevealed {
                        Capsule()
                            .fill(.svOnSurfaceVariant)
                            .frame(width: 26, height: 2)
                            .rotationEffect(.degrees(-45))
                    }
                }
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isRevealed ? "Hide password" : "Show password")
    }
}

#Preview("States") {
    struct Demo: View {
        @State private var empty = ""
        @State private var weak = "123"
        @State private var plain = "Daily Commuter"
        @State private var isPasswordValid = false

        var body: some View {
            VStack(spacing: 16) {
                CustomTextFieldView(
                    placeholder: "Create a secure password",
                    text: $empty,
                    icon: .icLock,
                    isSecure: true,
                    rules: [.required(), .minLength(8), .containsDigit()],
                    onValidationChange: { isPasswordValid = $0 }
                )
                CustomTextFieldView(
                    placeholder: "Create a secure password",
                    text: $weak,
                    icon: .icLock,
                    isSecure: true,
                    rules: [.required(), .minLength(8), .containsDigit()]
                )
                CustomTextFieldView(
                    placeholder: "Vehicle nickname",
                    text: $plain,
                    icon: .icDirectionsCar,
                    rules: [.maxLength(20)]
                )
                CustomTextFieldView(
                    placeholder: "Vehicle nickname",
                    text: $plain,
                    icon: .icDirectionsCar,
                    isEnabled: false
                )
                Text(isPasswordValid ? "Valid" : "Invalid")
            }
            .padding(16)
        }
    }
    return Demo()
}
