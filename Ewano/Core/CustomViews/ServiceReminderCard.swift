//
//  ServiceReminderCard.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI

struct ServiceReminderCard: View {
    let serviceName: String
    let intervalText: String
    let remainingDistance: String
    let dueText: String
    let progress: Double
    var heading: String = "NEXT SERVICE"
    var remainingLabel: String = "mi remaining"
    var bookingTitle: String = "Book"
    var onBook: () -> Void

    private var clampedProgress: Double {
        progress.isFinite ? min(max(progress, 0), 1) : 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                headingLabel
                Spacer(minLength: 12)
                VStack {
                    BadgeView(
                        text: intervalText,
                        textFont: .svBodySm,
                        textColor: .svInverseOnSurface, backgroundColor: .white.opacity(0.10),
                        verticalPadding: 4,
                        horizontalPadding: 14
                    )

                }
            }

            VStack(alignment: .leading, spacing: 0) {
                Text(serviceName.uppercased())
                    .font(.svHeadlineMobile)
                    .foregroundStyle(.svInverseOnSurface)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    distanceLabel
                    remainingText
                }
            }

            GeometryReader { geometry in
                Capsule()
                    .fill(.white.opacity(0.20))
                    .overlay(alignment: .leading) {
                        Capsule()
                            .fill(.svTertiaryFixed)
                            .frame(width: geometry.size.width * clampedProgress)
                    }
            }
            .frame(height: 7)
            .accessibilityLabel("Service interval completed")
            .accessibilityValue(Text(clampedProgress, format: .percent.precision(.fractionLength(0))))

            HStack() {
                dueLabel
                Spacer(minLength: 0)
                bookingButton
                    .fixedSize()
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            Color.svInverseSurface
                .overlay(alignment: .bottomTrailing) {
                    Circle()
                        .fill(.white.opacity(0.045))
                        .frame(width: 168, height: 168)
                        .offset(x: 48, y: 48)
                }
        }
        .clipShape(RoundedRectangle(cornerRadius: 36))
        .shadow(color: .black.opacity(0.12), radius: 3, y: 3)
    }

    private var headingLabel: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(.svTertiaryFixedDim)
                .frame(width: 9, height: 9)
            Text(heading)
                .font(.svLabel)
                .tracking(2)
                .foregroundStyle(.svInverseOnSurface.opacity(0.78))
        }
        .fixedSize()
    }

    private var distanceLabel: some View {
        Text(remainingDistance)
            .font(.svNumberXl)
            .foregroundStyle(.svTertiaryFixed)
    }

    private var remainingText: some View {
        Text(remainingLabel)
            .font(.svTitle)
            .foregroundStyle(.svInverseOnSurface.opacity(0.78))
    }

    private var dueLabel: some View {
        HStack(spacing: 8) {
            Image(.icEvent)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 18, height: 18)
                .foregroundStyle(.svTertiaryFixed)
                .accessibilityHidden(true)
            Text(dueText)
                .font(.svBody)
                .foregroundStyle(.svInverseOnSurface.opacity(0.78))
        }
    }

    private var bookingButton: some View {
        Button(action: onBook) {
            HStack(spacing: 6) {
                Text(bookingTitle)
                    .font(.svTitle)
                Image(.icArrowForward)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .accessibilityHidden(true)
            }
            .foregroundStyle(.svTertiaryFixed)
            .frame(minWidth: 44, minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(bookingTitle) \(serviceName)")
    }
}

#Preview("Service reminder") {
    ServiceReminderCard(
        serviceName: "Coolant change",
        intervalText: "Every 30,000 mi",
        remainingDistance: "3,000",
        dueText: "or by Mar 2027 · est. 4 months",
        progress: 0.75,
        onBook: {}
    )
    .padding()
    .frame(width: .infinity)
    .background(.svBackground)
}

#Preview("Large text") {
    ServiceReminderCard(
        serviceName: "Coolant change",
        intervalText: "Every 30,000 mi",
        remainingDistance: "3,000",
        dueText: "or by Mar 2027 · est. 4 months",
        progress: 0.75,
        onBook: {}
    )
    .padding()
    .environment(\.dynamicTypeSize, .accessibility1)
}
