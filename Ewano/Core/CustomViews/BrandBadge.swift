//
//  BrandBadge.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/26.
//

import SwiftUI

struct BrandBadge: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(.icDirectionsCarFill)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 20, height: 20)
                .accessibilityHidden(true)

            HStack(spacing: 2) {
                Text("SERVIO")
                    .tracking(0.8)
                Text("✱")
                    .foregroundStyle(.svTertiaryFixed)
                    .accessibilityHidden(true)
            }
            .font(.svBrandMark)
        }
        .foregroundStyle(.svInverseOnSurface)
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(.svSurfaceLowest.opacity(0.10), in: Capsule())
        .background(.ultraThinMaterial, in: Capsule())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Servio")
    }
}

#Preview {
    BrandBadge()
        .padding()
        .background(.svInverseSurface)
}
