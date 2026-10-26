//
//  CardSurface.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI

struct CardSurface: ViewModifier {
    var cornerRadius: CGFloat = 24
    var hasShadow: Bool = true

    func body(content: Content) -> some View {
        content
            .background(Color.svSurfaceLowest, in: RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(hasShadow ? 0.06 : 0), radius: 3, y: 2)
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

extension View {
    func cardSurface(cornerRadius: CGFloat = 24, hasShadow: Bool = true) -> some View {
        modifier(CardSurface(cornerRadius: cornerRadius, hasShadow: hasShadow))
    }
}
