//
//  IconCircleView.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI

struct IconCircleView: View {
    let icon: ImageResource
    var foreground: Color = .svOnSurfaceVariant
    var background: Color = .svSurfaceContainer
    var diameter: CGFloat = 56
    var iconSize: CGFloat = 24

    var body: some View {
        Image(icon)
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: iconSize, height: iconSize)
            .foregroundStyle(foreground)
            .frame(width: diameter, height: diameter)
            .background(background, in: Circle())
            .accessibilityHidden(true)
    }
}

#Preview {
    HStack {
        IconCircleView(icon: .icCalendarToday)
        IconCircleView(icon: .icWarningFill, foreground: .svOnErrorContainer, background: .svErrorContainer)
    }
    .padding()
}
