//
//  ServiceStatusRow.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

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

    var icon: ImageResource {
        switch self {
        case .overdue: .icReportFill
        case .dueSoon: .icWarningFill
        case .ok: .icCheckCircleFill
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
        case .overdue: .svErrorContainer
        case .dueSoon: .svTertiaryFixed
        case .ok: .svSurfaceHigh
        }
    }

    fileprivate var badgeForeground: Color {
        switch self {
        case .overdue: .svOnErrorContainer
        case .dueSoon: .svOnTertiaryContainer
        case .ok: .svOnSurfaceVariant
        }
    }

    fileprivate var progressColor: Color {
        switch self {
        case .overdue: .svError
        case .dueSoon: .svTertiaryContainer
        case .ok: .svPrimary
        }
    }
}

/// Unit for distance-based services. Both values of a service use the same unit,
/// so no conversion is ever done.
enum DistanceUnit {
    case kilometers
    case miles

    fileprivate var symbol: String {
        switch self {
        case .kilometers: "km"
        case .miles: "mi"
        }
    }
}

/// How a service is measured. The caller only says *what* is measured;
/// the row calculates progress, remaining amount, status, icon and colour.
enum ServiceInterval {
    enum TimeUnit {
        case days
        case months

        fileprivate var component: Calendar.Component {
            switch self {
            case .days: .day
            case .months: .month
            }
        }
    }

    /// Interval and distance driven since the last service, both in `unit`.
    case distance(interval: Double, driven: Double, unit: DistanceUnit = .kilometers)
    /// Interval (in days or months), the last service date and "now".
    case time(interval: Int, unit: TimeUnit, lastService: Date, now: Date = .now)

    /// Total length and elapsed part, in the chosen distance unit or whole days (time).
    /// `nil` means the input is invalid. Status and percentage both use this.
    fileprivate var measure: Measure? {
        switch self {
        case let .distance(interval, driven, _):
            guard interval.isFinite, interval > 0, driven.isFinite, driven >= 0 else { return nil }
            return Measure(total: interval, elapsed: driven)

        case let .time(interval, unit, lastService, now):
            guard interval > 0 else { return nil }
            let calendar = Calendar.current
            let start = calendar.startOfDay(for: lastService)
            let today = calendar.startOfDay(for: now)
            // Calendar arithmetic handles different month lengths and leap years.
            guard let due = calendar.date(byAdding: unit.component, value: interval, to: start),
                  let total = calendar.dateComponents([.day], from: start, to: due).day,
                  let elapsed = calendar.dateComponents([.day], from: start, to: today).day,
                  total > 0, elapsed >= 0
            else { return nil }
            return Measure(total: Double(total), elapsed: Double(elapsed))
        }
    }

    fileprivate var intervalText: String {
        switch self {
        case let .distance(interval, _, unit):
            return "Interval: every \(Self.distance(interval, unit))"
        case let .time(interval, unit, _, _):
            let word = switch unit {
            case .days: interval == 1 ? "day" : "days"
            case .months: interval == 1 ? "month" : "months"
            }
            return "Interval: every \(interval) \(word)"
        }
    }

    /// Formats a remaining/overdue amount in the unit this interval uses.
    fileprivate func format(_ amount: Double) -> String {
        switch self {
        case let .distance(_, _, unit):
            return Self.distance(amount, unit)
        case .time:
            let days = Int(amount)
            return "\(days) \(days == 1 ? "day" : "days")"
        }
    }

    private static func distance(_ value: Double, _ unit: DistanceUnit) -> String {
        "\(value.formatted(.number.precision(.fractionLength(0)))) \(unit.symbol)"
    }

    fileprivate struct Measure {
        let total: Double
        let elapsed: Double
        var remaining: Double { total - elapsed }
    }
}

struct ServiceStatusRow: View {
    enum Layout {
        case standard
        case compact
    }

    /// Optional glyph (e.g. oil can, brake disc). When nil, the status icon is used.
    var icon: ImageResource?
    let title: String
    let interval: ServiceInterval
    var layout: Layout = .standard
    var onTap: (() -> Void)?

    init(
        icon: ImageResource? = nil,
        title: String,
        interval: ServiceInterval,
        layout: Layout = .standard,
        onTap: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.interval = interval
        self.layout = layout
        self.onTap = onTap
    }

    /// Convenience for distance-based services. Both values must use `distanceUnit`.
    init(
        icon: ImageResource? = nil,
        title: String,
        serviceInterval: Double,
        currentDistance: Double,
        distanceUnit: DistanceUnit = .kilometers,
        layout: Layout = .standard,
        onTap: (() -> Void)? = nil
    ) {
        self.init(
            icon: icon,
            title: title,
            interval: .distance(interval: serviceInterval, driven: currentDistance, unit: distanceUnit),
            layout: layout,
            onTap: onTap
        )
    }

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    /// Service is "due soon" when this fraction of the interval (or less) remains.
    private static let dueSoonThreshold = 0.1

    // MARK: - Calculations

    private var measure: ServiceInterval.Measure? {
        interval.measure
    }

    private var isValidInput: Bool {
        measure != nil
    }

    private var status: ServiceStatus {
        guard let measure else { return .overdue } // not shown: body renders invalidContent
        if measure.elapsed >= measure.total {
            return .overdue
        }
        if measure.remaining <= measure.total * Self.dueSoonThreshold {
            return .dueSoon
        }
        return .ok
    }

    /// Bar fill, 0...1. Capped for display only; `status` is calculated separately.
    private var clampedProgress: Double {
        guard let measure else { return 0 }
        return min(max(measure.elapsed / measure.total, 0), 1)
    }

    /// Whole-number percentage, 0...100. Never 100 unless the service is overdue.
    private var elapsedPercent: Int {
        guard let measure else { return 0 }
        if status == .overdue { return 100 }
        let percent = Int((measure.elapsed * 100 / measure.total).rounded())
        return min(max(percent, 0), 99)
    }

    private var displayIcon: ImageResource {
        icon ?? status.icon
    }

    // MARK: - Text

    private var intervalText: String {
        interval.intervalText
    }

    private var valueText: String {
        guard let measure else { return "" }
        if status == .overdue {
            // Exactly at the interval: nothing has been exceeded yet.
            if measure.remaining == 0 { return "Service due" }
            return "\(interval.format(-measure.remaining)) overdue"
        }
        return interval.format(measure.remaining)
    }

    // MARK: - Body

    var body: some View {
        if !isValidInput {
            invalidContent
        } else if let onTap {
            Button(action: onTap) { content }
                .buttonStyle(.pressable)
        } else {
            content
        }
    }

    private var invalidContent: some View {
        HStack(spacing: 12) {
            IconCircleView(
                icon: .icWarningFill,
                foreground: .svOnErrorContainer,
                background: .svErrorContainer,
                diameter: 48,
                iconSize: 22
            )
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.svTitle)
                    .foregroundStyle(.svOnSurface)
                Text("Invalid service data")
                    .font(.svBodySm)
                    .foregroundStyle(.svError)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(cornerRadius: 28)
        .accessibilityElement(children: .combine)
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
                    icon: displayIcon,
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

    private var compactCaption: some View {
        Text("\(elapsedPercent)% elapsed")
            .font(.svBodySm)
            .foregroundStyle(.svOnSurfaceVariant)
            .lineLimit(1)
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
            icon: displayIcon,
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

private func daysAgo(_ days: Int) -> Date {
    Calendar.current.date(byAdding: .day, value: -days, to: .now) ?? .now
}

#Preview("All states") {
    VStack(spacing: 16) {
        // 7,750 / 7,500 -> overdue by 250 km (bar capped at 100%)
        ServiceStatusRow(title: "Tire Rotation", serviceInterval: 7_500, currentDistance: 7_750, onTap: {})
        // exactly at the interval -> "Service due"
        ServiceStatusRow(title: "Spark Plugs", serviceInterval: 10_000, currentDistance: 10_000)
        // 9,200 / 10,000 -> due soon, 800 km left
        ServiceStatusRow(title: "Engine Oil & Filter", serviceInterval: 10_000, currentDistance: 9_200)
        // 7,000 / 10,000 -> ok, 3,000 km left
        ServiceStatusRow(title: "Brake Fluid", serviceInterval: 10_000, currentDistance: 7_000)
        // miles: 4,560 / 6,000 -> ok, "1,440 mi", 76% elapsed
        ServiceStatusRow(title: "Brake Pads", serviceInterval: 6_000, currentDistance: 4_560, distanceUnit: .miles)
        // time-based: 12 months, last service 400 days ago -> overdue
        ServiceStatusRow(
            title: "Coolant Change",
            interval: .time(interval: 12, unit: .months, lastService: daysAgo(400))
        )
        // invalid input
        ServiceStatusRow(title: "Broken Data", serviceInterval: 0, currentDistance: 100)
    }
    .padding(16)
    .frame(width: 430)
    .background(.svBackground)
}

#Preview("Large text") {
    ServiceStatusRow(title: "Tire Rotation", serviceInterval: 7_500, currentDistance: 7_750)
        .padding()
        .environment(\.dynamicTypeSize, .accessibility1)
}

#Preview("Compact") {
    VStack(spacing: 16) {
        ServiceStatusRow(icon: .icOilBarrelFill, title: "Engine Oil & Filter",
                         serviceInterval: 10_000, currentDistance: 7_600, layout: .compact)   // 76% elapsed
        ServiceStatusRow(icon: .icAlbum, title: "Brake Fluid Flush",
                         serviceInterval: 20_000, currentDistance: 11_600, layout: .compact)  // 58% elapsed
        ServiceStatusRow(icon: .icAir, title: "Cabin Air Filter",
                         interval: .time(interval: 6, unit: .months, lastService: daysAgo(40)),
                         layout: .compact)
        ServiceStatusRow(icon: .icTireRepair, title: "Tire Rotation",
                         serviceInterval: 7_500, currentDistance: 7_750, layout: .compact)    // 100% elapsed, overdue
        ServiceStatusRow(icon: .icAlbum, title: "Brake Pads",
                         serviceInterval: 6_000, currentDistance: 4_560, distanceUnit: .miles,
                         layout: .compact)                                                    // 1,440 mi, 76% elapsed
    }
    .padding(16)
    .frame(width: 430)
    .background(.svBackground)
}

#Preview("Compact large text") {
    ServiceStatusRow(
        icon: .icTireRepair,
        title: "Tire Rotation",
        serviceInterval: 7_500,
        currentDistance: 7_750,
        layout: .compact
    )
    .padding()
    .environment(\.dynamicTypeSize, .accessibility1)
}
