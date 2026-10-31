//
//  SettingsRowView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/29.
//

import SwiftUI

struct SettingsRowView: View {
    let icon: ImageResource
    let title: String
    var showsChevron: Bool = true
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                IconCircleView(
                    icon: icon,
                    foreground: .svOnSurfaceVariant,
                    background: .svSurfaceContainer,
                    diameter: 36,
                    iconSize: 18
                )

                Text(title)
                    .font(.svBodySm)
                    .foregroundStyle(.svOnSurface)
                    .multilineTextAlignment(.leading)

                Spacer(minLength: 8)

                if showsChevron {
                    Image(.icChevronRight)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.svOnSurface)
                        .accessibilityHidden(true)
                }
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.pressable)
    }
}

#Preview {
    VStack {
        SettingsRowView(icon: .icInfo, title: "About Us")
        SettingsRowView(icon: .icLogout, title: "Log Out")
    }
    .padding()
    .cardSurface()
    .padding()
    .background(.svSurfaceHigh)
}
