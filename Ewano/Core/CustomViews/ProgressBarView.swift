//
//  ProgressBarView.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI

struct ProgressBarView: View {
    let progress: Double
    var fillColor: Color = .svPrimary
    var trackColor: Color = .svSurfaceHigh
    var height: CGFloat = 8

    private var clampedProgress: Double {
        progress.isFinite ? min(max(progress, 0), 1) : 0
    }

    var body: some View {
        Capsule()
            .fill(trackColor)
            .overlay(alignment: .leading) {
                GeometryReader { geometry in
                    Capsule()
                        .fill(fillColor)
                        .frame(width: geometry.size.width * clampedProgress)
                }
            }
            .frame(height: height)
    }
}

#Preview {
    VStack(spacing: 16) {
        ProgressBarView(progress: 0)
        ProgressBarView(progress: 0.5)
        ProgressBarView(progress: 1, fillColor: .svError)
    }
    .padding()
}
