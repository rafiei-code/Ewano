//
//  LoadingView.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI
import Lottie

struct LoadingView: View {
    var title: String?

    var body: some View {
        VStack(spacing: 12) {
            LottieView(animation: .loaderSimple)
                .playing(loopMode: .loop)
                .frame(width: 72, height: 72)
                .accessibilityHidden(true)

            if let title {
                Text(title)
                    .font(.svBody)
                    .foregroundStyle(.svOnSurfaceVariant)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title ?? "Loading")
    }
}

#Preview {
    LoadingView(title: "Loading your vehicles")
        .background(.svBackground)
}
