//
//  PageIndicator.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI

struct PageIndicator: View {
    let pageCount: Int
    let currentPage: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<pageCount, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? .svTertiaryFixed : .svInverseOnSurface.opacity(0.20))
                    .frame(width: index == currentPage ? 32 : 12, height: 6)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: currentPage)
        .accessibilityElement()
        .accessibilityLabel("Step \(currentPage + 1) of \(pageCount)")
    }
}

#Preview {
    PageIndicator(pageCount: 3, currentPage: 0)
        .padding()
        .background(.svInverseSurface)
}
