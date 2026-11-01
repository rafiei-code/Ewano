//
//  BottomActionBar.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import SwiftUI

/// The page's main action, pinned to the bottom. Used in `.safeAreaInset(edge: .bottom)` it also rides on top of the keyboard.
struct BottomActionBar<Content: View>: View {
    private let background: Color
    private let content: Content

    init(background: Color = .svSurface, @ViewBuilder content: () -> Content) {
        self.background = background
        self.content = content()
    }

    var body: some View {
        content
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 8)
            .frame(maxWidth: .infinity)
            .background {
                Rectangle()
                    .fill(background.opacity(0.9))
                    .background(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.06), radius: 8, y: -4)
                    .ignoresSafeArea(edges: .bottom)
            }
    }
}

#Preview {
    ScrollView {
        Color.svSurfaceHigh.frame(height: 900)
    }
    .safeAreaInset(edge: .bottom) {
        BottomActionBar {
            CustomButtonView(config: .init(title: "CONTINUE", trailingImage: .icArrowForward, titleFont: .svButton)) {}
        }
    }
}
