//
//  StatusCountChip.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import SwiftUI

struct StatusCountChip: View {
    let color: Color
    let title: String

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
                .accessibilityHidden(true)
            Text(title)
                .font(.svLabel)
                .bold()
                .foregroundStyle(.svOnSurface)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background {
            Capsule()
                .fill(.svSurfaceLowest)
                .shadow(color: .black.opacity(0.06), radius: 2, y: 1)
        }
    }
}

#Preview {
    HStack {
        StatusCountChip(color: .svError, title: "1 Overdue")
        StatusCountChip(color: .svTertiaryContainer, title: "2 Due Soon")
        StatusCountChip(color: .svPrimary, title: "9 OK")
    }
    .padding()
    .background(.svSurface)
}
