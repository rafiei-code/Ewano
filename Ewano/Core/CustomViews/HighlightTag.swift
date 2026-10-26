//
//  HighlightTag.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI

struct HighlightTag: View {
    enum Style {
        case onDark
        case onLight
    }

    let title: String
    var style: Style = .onDark

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(style == .onDark ? .svTertiaryFixed : .svTertiary)
                .frame(width: style == .onDark ? 6 : 8, height: style == .onDark ? 6 : 8)
                .accessibilityHidden(true)
            Text(title.uppercased())
                .font(style == .onDark ? .svBodySm : .svLabel)
                .tracking(style == .onDark ? 0.35 : 0.65)
                .foregroundStyle(style == .onDark ? .svSurfaceHighest : .svOnSurfaceVariant)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, style == .onDark ? 4 : 6)
        .background { background }
    }

    @ViewBuilder
    private var background: some View {
        switch style {
        case .onDark:
            Capsule()
                .fill(.svInverseOnSurface.opacity(0.10))
                .background(.ultraThinMaterial, in: Capsule())
        case .onLight:
            Capsule()
                .fill(.svSurfaceContainer)
                .shadow(color: .black.opacity(0.06), radius: 2, y: 1)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        HighlightTag(title: "Intelligent vehicle care")
            .padding()
            .background(.svInverseSurface)
        HighlightTag(title: "Servio garage sync", style: .onLight)
            .padding()
            .background(.svSurfaceHigh)
    }
}
