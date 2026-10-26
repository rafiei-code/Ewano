//
//  StatTileView.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI

struct StatTileView: View {

    enum ValueStyle {
        case number
        case text
    }

    let title: String
    let value: String
    let icon: ImageResource
    var unit: String?
    var valueStyle: ValueStyle = .text
    var iconForeground: Color = .svOnSurfaceVariant
    var iconBackground: Color = .svSurfaceContainer

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        Group {
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: 12) {
                    iconView
                    textBlock
                }
            } else {
                HStack(spacing: 14) {
                    iconView
                    textBlock
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.svSurfaceHigh, in: RoundedRectangle(cornerRadius: 24))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
        .accessibilityValue([value, unit].compactMap { $0 }.joined(separator: " "))
    }

    private var iconView: some View {
        IconCircleView(
            icon: icon,
            foreground: iconForeground,
            background: iconBackground,
            diameter: 56,
            iconSize: 24
        )
    }

    private var textBlock: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title.uppercased())
                .font(.svLabel)
                .tracking(1)
                .foregroundStyle(.svOnSurfaceVariant)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            valueView
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var valueView: some View {
        switch valueStyle {
        case .number:
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.svHeadlineMobile)
                    .foregroundStyle(.svOnSurface)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                if let unit {
                    Text(unit)
                        .font(.svBodySm)
                        .foregroundStyle(.svOnSurfaceVariant)
                        .lineLimit(1)
                }
            }
        case .text:
            Text(value)
                .font(.svTitle)
                .foregroundStyle(.svOnSurface)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}

#Preview("Stat tiles") {
    HStack(spacing: 12) {
        StatTileView(
            title: "Latest odometer",
            value: "45,250",
            icon: .icSpeed,
            unit: "mi",
            valueStyle: .number,
            iconForeground: .svOnTertiaryFixed,
            iconBackground: .svTertiaryFixed
        )
        StatTileView(
            title: "Schedule status",
            value: "100% Up to date",
            icon: .icVerified,
            iconForeground: .svPrimary,
            iconBackground: .svSecondaryContainer
        )
    }
    .padding(16)
    .background(.svBackground)
}

#Preview("Large text") {
    StatTileView(
        title: "Latest odometer",
        value: "45,250",
        icon: .icSpeed,
        unit: "mi",
        valueStyle: .number
    )
    .padding()
    .environment(\.dynamicTypeSize, .accessibility1)
}
