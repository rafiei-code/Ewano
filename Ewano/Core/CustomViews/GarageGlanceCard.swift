//
//  GarageGlanceCard.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI

struct GarageGlanceCard: View {
    let image: ImageResource
    let status: String
    let detail: String
    let title: String
    let subtitle: String
    var icon: ImageResource = .icBuildCircleFill

    var body: some View {
        HStack(spacing: 12) {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(status.uppercased())
                        .foregroundStyle(.svTertiary)
                    Circle()
                        .fill(.svOutlineVariant)
                        .frame(width: 4, height: 4)
                        .accessibilityHidden(true)
                    Text(detail)
                        .foregroundStyle(.svOnSurfaceVariant)
                }
                .font(.svLabel)
                .lineLimit(1)

                Text(title)
                    .font(.svTitle)
                    .foregroundStyle(.svOnSurface)
                    .lineLimit(1)

                Text(subtitle)
                    .font(.svBodySm)
                    .foregroundStyle(.svOnSurfaceVariant)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)

            IconCircleView(
                icon: icon,
                foreground: .svTertiary,
                background: .svSurfaceLowest,
                diameter: 36,
                iconSize: 20
            )
            .shadow(color: .black.opacity(0.06), radius: 2, y: 1)
        }
        .padding(12)
        .background(.svSurfaceContainer, in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.06), radius: 2, y: 1)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    GarageGlanceCard(
        image: .imgLoginFleet,
        status: "Active fleet",
        detail: "Ready to Sync",
        title: "2 Vehicles Monitored",
        subtitle: "Next due: Oil & Filter in 420 mi"
    )
    .padding()
    .background(.svSurfaceHigh)
}
