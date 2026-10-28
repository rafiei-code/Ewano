//
//  AppHeaderView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import SwiftUI

struct AppHeaderView: View {
    var profileImageURL: String?
    var onNotifications: () -> Void = {}
    var onProfile: () -> Void = {}

    var body: some View {
        HStack(spacing: 8) {
            Image(.imgServioLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .accessibilityHidden(true)

            HStack(spacing: 4) {
                Text("SERVIO")
                    .foregroundStyle(.svOnSurface)
                Text("✱")
                    .foregroundStyle(.svTertiaryContainer)
                    .accessibilityHidden(true)
            }
            .font(.svHeadlineMobile)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Servio")
            .accessibilityAddTraits(.isHeader)

            Spacer(minLength: 8)

            Button(action: onNotifications) {
                Image(.icNotifications)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.svOnSurface)
                    .frame(width: 44, height: 44)
                    .contentShape(Circle())
            }
            .buttonStyle(.pressable)
            .accessibilityLabel("Notifications")

            Button(action: onProfile) {
                avatar
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                    .frame(width: 44, height: 44)
                    .contentShape(Circle())
            }
            .buttonStyle(.pressable)
            .accessibilityLabel("Profile")
        }
        .padding(.horizontal, 20)
        .frame(height: 64)
        .background {
            Rectangle()
                .fill(.svSurface.opacity(0.85))
                .background(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 1)
                .ignoresSafeArea(edges: .top)
        }
    }

    @ViewBuilder
    private var avatar: some View {
        if let profileImageURL {
            AppImage(type: .url(profileImageURL), contentMode: .fill)
        } else {
            IconCircleView(
                icon: .icPerson,
                foreground: .svOnSecondaryContainer,
                background: .svSecondaryContainer,
                diameter: 32,
                iconSize: 18
            )
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        AppHeaderView()
        Spacer()
    }
    .background(.svSurface)
}
