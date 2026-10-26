//
//  ServiceStatusRow.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI

enum ServiceStatus: CaseIterable {
    case overdue
    case dueSoon
    case ok

    var badgeTitle: String {
        switch self {
        case .overdue: "OVERDUE"
        case .dueSoon: "DUE SOON"
        case .ok: "OK"
        }
    }

    var compactBadgeTitle: String {
        switch self {
        case .overdue: "Overdue"
        case .dueSoon: "Due Soon"
        case .ok: "OK"
        }
    }

    fileprivate var iconBackground: Color {
        switch self {
        case .overdue: .svErrorContainer
        case .dueSoon: .svTertiaryFixed
        case .ok: .svSecondaryContainer
        }
    }

    fileprivate var iconForeground: Color {
        switch self {
        case .overdue: .svOnErrorContainer
        case .dueSoon: .svOnTertiaryFixed
        case .ok: .svPrimary
        }
    }

    fileprivate var valueColor: Color {
        switch self {
        case .overdue: .svError
        case .dueSoon: .svOnTertiaryContainer
        case .ok: .svOnSurface
        }
    }

    fileprivate var badgeBackground: Color {
        switch self {
        case .overdue:
                .svErrorContainer
        case .dueSoon:
                .svTertiaryFixed
        case .ok:
                .svSurfaceHigh
        }
    }

    fileprivate var badgeForeground: Color {
        switch self {
        case .overdue:
                .svOnErrorContainer
        case .dueSoon:
                .svOnTertiaryContainer
        case .ok:
                .svOnSurfaceVariant
        }
    }

    fileprivate var progressColor: Color {
        switch self {
        case .overdue:
                .svError
        case .dueSoon:
                .svTertiaryContainer
        case .ok:
                .svPrimary
        }
    }
}

struct ServiceStatusRow: View {
    enum Layout {
        case standard
        case compact
    }

    let icon: ImageResource
    let title: String
    let intervalText: String
    let valueText: String
    let status: ServiceStatus
    let progress: Double
    var layout: Layout = .standard
    var captionText: String?
    var onTap: (() -> Void)?

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var clampedProgress: Double {
        guard progress.isFinite else { return 0 }
        return status == .overdue ? 1 : min(max(progress, 0), 1)
    }

    var body: some View {
        if let onTap {
            Button(action: onTap) { content }
                .buttonStyle(.pressable)
        } else {
            content
        }
    }

    @ViewBuilder
    private var content: some View {
        switch layout {
        case .standard: standardContent
        case .compact: compactContent
        }
    }

    private var compactContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                IconCircleView(
                    icon: icon,
                    foreground: status.iconForeground,
                    background: status.iconBackground,
                    diameter: 48,
                    iconSize: 22
                )
                titleBlock
                Spacer(minLength: 0)
                BadgeView(text: status.compactBadgeTitle, textFont: .svLabel, textColor: status.badgeForeground, backgroundColor: status.badgeBackground)
                    .fixedSize()
            }

            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: 4) {
                    compactValue
                    compactCaption
                }
            } else {
                HStack(alignment: .lastTextBaseline, spacing: 12) {
                    compactValue
                    Spacer(minLength: 0)
                    compactCaption
                }
            }

            progressBar
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(cornerRadius: 28)
        .accessibilityElement(children: .combine)
        .accessibilityValue(Text(clampedProgress, format: .percent.precision(.fractionLength(0))))
    }

    private var compactValue: some View {
        Text(valueText)
            .font(.svHeadlineMobile)
            .foregroundStyle(status.valueColor)
            .lineLimit(dynamicTypeSize.isAccessibilitySize ? nil : 1)
            .minimumScaleFactor(0.7)
    }

    @ViewBuilder
    private var compactCaption: some View {
        if let captionText {
            Text(captionText)
                .font(.svBodySm)
                .foregroundStyle(.svOnSurfaceVariant)
                .lineLimit(1)
        }
    }

    private var standardContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                iconView

                if dynamicTypeSize.isAccessibilitySize {
                    VStack(alignment: .leading, spacing: 8) {
                        titleBlock
                        valueBlock(alignment: .leading)
                    }
                } else {
                    HStack(alignment: .top, spacing: 12) {
                        titleBlock
                        Spacer(minLength: 0)
                        valueBlock(alignment: .trailing)
                    }
                }
            }

            progressBar
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(cornerRadius: 32)
        .accessibilityElement(children: .combine)
        .accessibilityValue(Text(clampedProgress, format: .percent.precision(.fractionLength(0))))
    }

    private var iconView: some View {
        IconCircleView(
            icon: icon,
            foreground: status.iconForeground,
            background: status.iconBackground,
            diameter: 60,
            iconSize: 26
        )
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.svTitle)
                .foregroundStyle(.svOnSurface)
                .lineLimit(dynamicTypeSize.isAccessibilitySize ? nil : 1)
            Text(intervalText)
                .font(.svBodySm)
                .foregroundStyle(.svOnSurfaceVariant)
                .lineLimit(dynamicTypeSize.isAccessibilitySize ? nil : 1)
                .truncationMode(.tail)
        }
    }

    private func valueBlock(alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: 6) {
            Text(valueText.uppercased())
                .font(.svHeadlineMobile)
                .foregroundStyle(status.valueColor)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            BadgeView(text: status.badgeTitle, textFont: .svLabel, textColor: status.badgeForeground, backgroundColor: status.badgeBackground)
                .tracking(1.5)

        }
        .fixedSize(horizontal: true, vertical: false)
        .layoutPriority(1)
    }

    private var progressBar: some View {
        ProgressBarView(progress: clampedProgress, fillColor: status.progressColor)
            .accessibilityHidden(true)
    }
}

#Preview("All states") {
    VStack(spacing: 16) {
        ServiceStatusRow(
            icon: .icTireRepair,
            title: "Tire Rotation",
            intervalText: "every 7,500 mi or 12 months",
            valueText: "250 mi overdue",
            status: .overdue,
            progress: 1,
            onTap: {}
        )
        ServiceStatusRow(
            icon: .icModeFanFill,
            title: "Coolant Change",
            intervalText: "every 30,000 mi or 24 months",
            valueText: "3,000 mi",
            status: .dueSoon,
            progress: 0.85
        )
        ServiceStatusRow(
            icon: .icOilBarrelFill,
            title: "Engine Oil & Filter",
            intervalText: "every 5,000 mi or 6 months",
            valueText: "1,200 mi",
            status: .dueSoon,
            progress: 0.76
        )
        ServiceStatusRow(
            icon: .icMinorCrashFill,
            title: "Brake Fluid",
            intervalText: "every 20,000 mi or 24 months",
            valueText: "8,400 mi",
            status: .ok,
            progress: 0.28
        )
    }
    .padding(16)
    .frame(width: 430)
    .background(.svBackground)
}

#Preview("Large text") {
    ServiceStatusRow(
        icon: .icTireRepair,
        title: "Tire Rotation",
        intervalText: "every 7,500 mi or 12 months",
        valueText: "250 mi overdue",
        status: .overdue,
        progress: 1
    )
    .padding()
    .environment(\.dynamicTypeSize, .accessibility1)
}

#Preview("Compact") {
    VStack(spacing: 16) {
        ServiceStatusRow(
            icon: .icTireRepair,
            title: "Tire Rotation",
            intervalText: "Interval: every 7,500 mi",
            valueText: "250 mi overdue",
            status: .overdue,
            progress: 1,
            layout: .compact,
            captionText: "103% limit"
        )
        ServiceStatusRow(
            icon: .icAlbum,
            title: "Brake Fluid Flush",
            intervalText: "Interval: every 20,000 mi",
            valueText: "8,400 mi",
            status: .ok,
            progress: 0.58,
            layout: .compact,
            captionText: "58% life"
        )
        ServiceStatusRow(
            icon: .icAir,
            title: "Cabin Air Filter",
            intervalText: "Interval: every 15,000 mi",
            valueText: "11,750 mi",
            status: .ok,
            progress: 0.22,
            layout: .compact,
            captionText: "22% used"
        )
    }
    .padding(16)
    .frame(width: 430)
    .background(.svBackground)
}

#Preview("Compact large text") {
    ServiceStatusRow(
        icon: .icTireRepair,
        title: "Tire Rotation",
        intervalText: "Interval: every 7,500 mi",
        valueText: "250 mi overdue",
        status: .overdue,
        progress: 1,
        layout: .compact,
        captionText: "103% limit"
    )
    .padding()
    .environment(\.dynamicTypeSize, .accessibility1)
}
