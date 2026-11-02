//
//  PillButton.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import SwiftUI

/// Small gold capsule action, such as the schedule page's "Update".
struct PillButton: View {
    let title: String
    var icon: ImageResource?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon {
                    Image(icon)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .accessibilityHidden(true)
                }
                Text(title)
                    .font(.svLabel)
                    .bold()
                    .lineLimit(1)
            }
            .foregroundStyle(.svOnTertiaryContainer)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background {
                Capsule()
                    .fill(.svTertiaryContainer)
                    .shadow(color: .black.opacity(0.06), radius: 2, y: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PillButton(title: "Update", icon: .icEdit) {}
        .padding()
        .background(.svSurface)
}
