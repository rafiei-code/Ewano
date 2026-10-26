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

    init(
        text: String,
        textFont: Font = .svBody,
        textColor: Color = .svOnTertiaryFixed,
        backgroundColor: Color = .svOnTertiaryContainer
    ) {
        self.text = text
        self.textFont = textFont
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        HStack {
            Text(text)
                .font(textFont)
                .foregroundColor(textColor)
                .padding(8)

        }
        .background(backgroundColor)
        .clipShape(Capsule())
    }
}

#Preview {
    BadgeView(text: "hi")
    BadgeView(text: "hi", textColor: .svError, backgroundColor: .svTertiaryContainer)
}
