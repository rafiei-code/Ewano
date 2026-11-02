//
//  AccentTitleView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import SwiftUI

struct AccentTitleView: View {
    let title: String
    var font: Font = .svHeadlineMobile

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Text(title.uppercased())
                .foregroundStyle(.svOnSurface)
                .fixedSize(horizontal: false, vertical: true)
            Text("✱")
                .foregroundStyle(.svTertiaryContainer)
                .accessibilityHidden(true)
        }
        .font(font)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 16) {
        AccentTitleView(title: "Choose your brand")
        AccentTitleView(title: "Setup maintenance schedule")
    }
    .padding()
}
