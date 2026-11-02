//
//  AboutUsPageView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/11/01.
//

import SwiftUI

struct AboutUsPageView: View {
    private struct Principle: Hashable {
        let title: String
        let detail: String
    }

    private let principles = [
        Principle(
            title: "Factory Interval Accuracy",
            detail: "Direct OEM schedule mapping tailored precisely for your specific trim and engine specifications."
        ),
        Principle(
            title: "Private & Secure",
            detail: "Your garage and service records are tied to your account and only reachable after you sign in."
        )
    ]

    private var copyrightText: String {
        "Copyright © \(Calendar.current.component(.year, from: .now)) Servio Automotive Technologies Inc. All rights reserved."
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                hero

                VStack(alignment: .leading, spacing: 12) {
                    Text("BUILT FOR PEOPLE WHO LOVE THEIR CARS.")
                        .font(.svHeadlineMobile)
                        .foregroundStyle(.svOnSurface)
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityAddTraits(.isHeader)

                    Group {
                        Text("Servio was built by mechanics and automotive enthusiasts who believe vehicle maintenance shouldn't rely on guesswork or faded windshield reminder stickers.")
                        Text("By pairing factory-accurate service schedules with simple distance countdowns, we help you keep your vehicle running smoothly, maintain maximum resale value, and avoid costly unexpected repairs.")
                    }
                    .font(.svBody)
                    .foregroundStyle(.svOnSurfaceVariant)
                    .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 4)

                principlesCard

                footer
                    .padding(.top, 8)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 40)
        }
        .background(.svSurface)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                AccentTitleView(title: "About us", font: .svHeadlineMd)
                    .fixedSize()
            }
            .hiddenSharedBackground()
        }
    }

    private var hero: some View {
        Color.svInverseSurface
            .frame(height: 224)
            .overlay {
                Image(.imgAboutGarage)
                    .resizable()
                    .scaledToFill()
                    .accessibilityHidden(true)
            }
            .overlay {
                LinearGradient(
                    colors: [.clear, .svInverseSurface.opacity(0.6), .svInverseSurface],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text("SERVIO")
                            .font(.svHeadlineMobile)
                            .tracking(1.4)
                            .foregroundStyle(.svSurface)
                        Text("✱")
                            .font(.svHeadlineMd)
                            .foregroundStyle(.svTertiaryContainer)
                            .accessibilityHidden(true)
                    }
                    Text("INTELLIGENT VEHICLE CARE")
                        .font(.svLabel)
                        .tracking(1.3)
                        .foregroundStyle(.svTertiaryFixedDim)
                }
                .padding(20)
                .accessibilityElement(children: .combine)
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.12), radius: 6, y: 4)
    }

    private var principlesCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(.icVerified)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.svPrimary)
                    .accessibilityHidden(true)
                Text("Core Principles")
                    .font(.svTitle)
                    .foregroundStyle(.svOnSurface)
                    .accessibilityAddTraits(.isHeader)
            }

            ForEach(principles, id: \.self) { principle in
                HStack(alignment: .top, spacing: 12) {
                    IconCircleView(
                        icon: .icCheckCircleFill,
                        foreground: .svTertiary,
                        background: .svTertiary.opacity(0.15),
                        diameter: 28,
                        iconSize: 18
                    )
                    .padding(.top, 2)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(principle.title)
                            .font(.svBodySm)
                            .fontWeight(.semibold)
                            .foregroundStyle(.svOnSurface)
                        Text(principle.detail)
                            .font(.svBodySm)
                            .foregroundStyle(.svOnSurfaceVariant)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .accessibilityElement(children: .combine)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.svSurfaceLowest, in: RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }

    private var footer: some View {
        VStack(spacing: 4) {
            Text(copyrightText)
                .font(.svLabel)
                .foregroundStyle(.svOnSurfaceVariant)
                .multilineTextAlignment(.center)
            HStack(spacing: 8) {
                Circle()
                    .fill(.svTertiary)
                    .frame(width: 6, height: 6)
                    .accessibilityHidden(true)
                Text("Version \(Bundle.main.appVersion) (Build \(Bundle.main.buildNumber))")
                    .font(.svLabel)
                    .foregroundStyle(.svOutline)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        AboutUsPageView()
    }
}
