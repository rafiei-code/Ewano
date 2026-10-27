//
//  SocialSignInButton.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/26.
//

import SwiftUI

struct SocialSignInButton: View {
    enum Provider {
        case apple
        case google

        var title: String {
            switch self {
            case .apple: "Apple"
            case .google: "Google"
            }
        }
    }

    let provider: Provider
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                logo
                    .frame(width: 20, height: 20)
                    .accessibilityHidden(true)
                Text(provider.title)
                    .font(.svButton)
            }
            .foregroundStyle(.svOnSurface)
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(.svSurfaceLowest, in: RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.06), radius: 2, y: 1)
            .contentShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.pressable)
        .accessibilityLabel("Continue with \(provider.title)")
    }

    @ViewBuilder
    private var logo: some View {
        switch provider {
        case .apple:
            Image(systemName: "apple.logo")
                .resizable()
                .scaledToFit()
        case .google:
            Image(.logoGoogle)
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview {
    HStack(spacing: 12) {
        SocialSignInButton(provider: .apple) {}
        SocialSignInButton(provider: .google) {}
    }
    .padding()
    .background(.svSurfaceHigh)
}
