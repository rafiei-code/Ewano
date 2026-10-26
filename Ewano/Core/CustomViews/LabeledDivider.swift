//
//  LabeledDivider.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI

struct LabeledDivider: View {
    let title: String

    var body: some View {
        HStack(spacing: 16) {
            line
            Text(title)
                .font(.svBodySm)
                .foregroundStyle(.svOnSurfaceVariant)
                .layoutPriority(1)
            line
        }
    }

    private var line: some View {
        Rectangle()
            .fill(.svOutlineVariant.opacity(0.6))
            .frame(height: 1)
            .accessibilityHidden(true)
    }
}

#Preview {
    LabeledDivider(title: "or continue with")
        .padding()
        .background(.svSurfaceHigh)
}
