//
//  BadgeView.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI

struct BadgeView: View {

    let text: String
    let image: ImageResource?
    let textFont: Font
    let textColor: Color
    let imageColor: Color
    let backgroundColor: Color
    let verticalPadding: CGFloat
    let horizontalPadding: CGFloat

    init(
        text: String,
        image: ImageResource? = nil,
        textFont: Font = .svBody,
        textColor: Color = .svOnTertiaryFixed,
        imageColor: Color = .svOnTertiaryFixed,
        backgroundColor: Color = .svOnTertiaryContainer,
        verticalPadding: CGFloat = 4,
        horizontalPadding: CGFloat = 12

    ) {
        self.text = text
        self.image = image
        self.textFont = textFont
        self.textColor = textColor
        self.imageColor = imageColor
        self.backgroundColor = backgroundColor
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
    }

    var body: some View {
        HStack(spacing: 4) {
            if let image {
                Image(image)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(imageColor)
                    .frame(width: 18, height: 18)
            }

            Text(text)
                .font(textFont)
                .foregroundColor(textColor)

        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .background(backgroundColor)
        .clipShape(Capsule())
    }
}

#Preview {
    BadgeView(text: "hi", image: .icAddCircle)
    BadgeView(text: "hi", textColor: .svError, backgroundColor: .svTertiaryContainer)
}
