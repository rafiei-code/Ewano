//
//  GaugeLoaderView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import SwiftUI
import Lottie

/// The splash screen's spinning tachometer, reusable as a full-screen loading indicator.
struct GaugeLoaderView: View {
    var caption: String? = "CALIBRATING"

    var body: some View {
        ZStack {
            LottieView(animation: .gaugeLoader)
                .playing(loopMode: .loop)
                .frame(width: 240, height: 240)

            core
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Loading")
    }

    private var core: some View {
        VStack(spacing: -2) {
            Image(.icSpeed)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundStyle(.svTertiaryFixed)
                .shadow(color: .svTertiaryFixedDim.opacity(0.6), radius: 6)

            if let caption {
                Text(caption)
                    .font(.svGaugeCaption)
                    .tracking(0.55)
                    .foregroundStyle(.svTertiaryFixedDim)
            }
        }
        .frame(width: 80, height: 80)
        .background {
            Circle()
                .fill(.svInverseSurface.opacity(0.85))
                .overlay {
                    Circle().fill(
                        LinearGradient(
                            colors: [.svTertiaryFixed.opacity(0.2), .clear],
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                        )
                    )
                }
        }
    }
}

#Preview {
    GaugeLoaderView()
        .padding()
        .background(.svInverseSurface)
}
