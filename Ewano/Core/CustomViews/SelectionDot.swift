//
//  SelectionDot.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI

struct SelectionDot: View {
    let isSelected: Bool

    var body: some View {
        Circle()
            .fill(isSelected ? .svTertiaryContainer : .svSurfaceHigh)
            .frame(width: 32, height: 32)
            .overlay {
                if isSelected {
                    Image(.icCheck)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.svOnTertiaryContainer)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(.spring(duration: 0.25), value: isSelected)
            .accessibilityHidden(true)
    }
}
