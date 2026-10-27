//
//  FeatureHighlightRow.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/26.
//

import SwiftUI

struct FeatureHighlightRow: View {
    let icon: ImageResource
    let title: String
    let subtitle: String
    var onTap: (() -> Void)?

    var body: some View {
        if let onTap {
            Button(action: onTap) { content }
                .buttonStyle(.plain)
        } else {
            content
        }
    }

    private var content: some View {
        HStack(spacing: 12) {
            Image(icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(.svTertiaryFixed)
                .frame(width: 40, height: 40)
                .background(.svSurfaceHighest.opacity(0.10), in: RoundedRectangle(cornerRadius: 8))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.svNumberMd)
                    .foregroundStyle(.svInverseOnSurface)
                Text(subtitle)
                    .font(.svBodySm)
                    .foregroundStyle(.svOutlineVariant)
            }

            Spacer(minLength: 0)

            Image(.icChevronRight)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(.svOutlineVariant)
                .accessibilityHidden(true)
        }
        .padding(12)
        .background(.svInverseSurface.opacity(0.80), in: RoundedRectangle(cornerRadius: 12))
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.25), radius: 12, y: 8)
        .contentShape(RoundedRectangle(cornerRadius: 12))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    FeatureHighlightRow(
        icon: .icVerified,
        title: "OEM Precision",
        subtitle: "Factory scheduled intervals",
        onTap: {}
    )
    .padding()
    .background(.svInverseSurface)
}
