//
//  BadgeView.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI

struct BadgeView: View {

    let text: String
    let textFont: Font
    let textColor: Color
    let backgroundColor: Color
    let verticalPadding: CGFloat
    let horizontalPadding: CGFloat

    init(
        text: String,
        textFont: Font = .svBody,
        textColor: Color = .svOnTertiaryFixed,
        backgroundColor: Color = .svOnTertiaryContainer,
        verticalPadding: CGFloat = 4,
        horizontalPadding: CGFloat = 12
    ) {
        self.text = text
        self.textFont = textFont
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }

    var body: some View {
        HStack {
            Text(text)
                .font(textFont)
                .foregroundColor(textColor)
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)

        }
        .background(backgroundColor)
        .clipShape(Capsule())
    }
}

#Preview {
    BadgeView(text: "hi")
    BadgeView(text: "hi", textColor: .svError, backgroundColor: .svTertiaryContainer)
}
