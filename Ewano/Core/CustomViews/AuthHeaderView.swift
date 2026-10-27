//
//  AuthHeaderView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/27.
//

import SwiftUI
import Lottie

struct AuthHeaderView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 0) {
                Text(title)
                    .font(.svHeadlineMobile)
                    .foregroundStyle(.svOnSurface)
                    .accessibilityAddTraits(.isHeader)
                LottieView(animation: .loginStar)
                    .playing(loopMode: .loop)
                    .frame(width: 32, height: 32)
                    .accessibilityHidden(true)
            }

            Text(subtitle)
                .font(.svBody)
                .foregroundStyle(.svOnSurfaceVariant)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    AuthHeaderView(title: "CREATE ACCOUNT", subtitle: "Start tracking services, warranties, and mileage.")
        .padding()
        .background(.svSurfaceHigh)
}
