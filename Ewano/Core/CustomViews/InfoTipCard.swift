//
//  InfoTipCard.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/27.
//

import SwiftUI

struct InfoTipCard: View {
    let icon: ImageResource
    let title: String
    let subtitle: String
    var iconColor: Color = .svOnSurfaceVariant
    var badge: String?
    var background: Color = .svSurfaceContainer

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundStyle(iconColor)
                .padding(.top, 1)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.svLabel)
                    .bold()
                    .foregroundStyle(.svOnSurface)
                Text(subtitle)
                    .font(.svBodySm)
                    .foregroundStyle(.svOnSurfaceVariant)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)

            if let badge {
                BadgeView(
                    text: badge.uppercased(),
                    textFont: .svLabel,
                    textColor: .svOnSurfaceVariant,
                    backgroundColor: .svSurfaceHighest,
                    verticalPadding: 2,
                    horizontalPadding: 8
                )
                .fixedSize()
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(background, in: RoundedRectangle(cornerRadius: 12))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    VStack(spacing: 16) {
        InfoTipCard(
            icon: .icSpeed,
            title: "Dispatch Status: Verified",
            subtitle: "Valid for 15 minutes",
            iconColor: .svTertiary,
            badge: "TLS 1.3",
            background: .svSurfaceLow
        )
        InfoTipCard(
            icon: .icHelpOutline,
            title: "Check your spam or junk folder",
            subtitle: "If it doesn't arrive within a minute, check that you used the email you signed up with."
        )
    }
    .padding()
    .background(.svSurfaceHigh)
}
