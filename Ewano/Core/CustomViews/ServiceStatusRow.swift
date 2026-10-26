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
    let icon: ImageResource
    let title: String
    let intervalText: String
    let valueText: String
    let status: ServiceStatus
    let progress: Double
    var onTap: (() -> Void)?

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var clampedProgress: Double {
        guard progress.isFinite else { return 0 }
        return status == .overdue ? 1 : min(max(progress, 0), 1)
    }

    var body: some View {
        if let onTap {
            Button(action: onTap) { content }
                .buttonStyle(.plain)
        } else {
            content
        }
    }

    private var content: some View {
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
        .background(Color.svSurfaceLowest, in: RoundedRectangle(cornerRadius: 32))
        .shadow(color: .black.opacity(0.06), radius: 3, y: 2)
        .contentShape(RoundedRectangle(cornerRadius: 32))
        .accessibilityElement(children: .combine)
        .accessibilityValue(Text(clampedProgress, format: .percent.precision(.fractionLength(0))))
    }

    private var iconView: some View {
        Image(icon)
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: 26, height: 26)
            .foregroundStyle(status.iconForeground)
            .frame(width: 60, height: 60)
            .background(status.iconBackground, in: Circle())
            .accessibilityHidden(true)
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
        GeometryReader { geometry in
            Capsule()
                .fill(Color.svSurfaceHigh)
                .overlay(alignment: .leading) {
                    Capsule()
                        .fill(status.progressColor)
                        .frame(width: geometry.size.width * clampedProgress)
                }
        }
        .frame(height: 8)
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
