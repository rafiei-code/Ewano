//
//  HighlightTag.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI

struct HighlightTag: View {
    let title: String

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(.svTertiaryFixed)
                .frame(width: 6, height: 6)
                .accessibilityHidden(true)
            Text(title.uppercased())
                .font(.svBodySm)
                .tracking(0.35)
                .foregroundStyle(.svSurfaceHighest)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(.svInverseOnSurface.opacity(0.10), in: Capsule())
        .background(.ultraThinMaterial, in: Capsule())
    }
}

#Preview {
    HighlightTag(title: "Intelligent vehicle care")
        .padding()
        .background(.svInverseSurface)
}
