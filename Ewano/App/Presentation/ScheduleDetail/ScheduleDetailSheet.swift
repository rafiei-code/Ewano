//
//  ScheduleDetailSheet.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/29.
//

import SwiftUI

struct ScheduleDetailSheet: View {
    let maintenance: MaintenanceModel
    let icon: ImageResource?

    @Environment(\.dismiss) private var dismiss

    private var status: ServiceStatus? {
        maintenance.serviceStatus
    }

    private var remainingDays: Int? {
        guard let due = maintenance.dueDate else { return nil }
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: calendar.startOfDay(for: .now), to: due).day
    }

    private var remainingValue: String {
        guard let remainingDays else { return maintenance.intervalKM.formatted() }
        return abs(remainingDays).formatted()
    }

    private var remainingUnit: String {
        remainingDays == nil ? "KM" : "DAYS"
    }

    private var reason: String? {
        if let notes = maintenance.notes, !notes.isEmpty { return notes }
        return maintenance.description.isEmpty ? nil : maintenance.description
    }

    private var statusBadge: (text: String, icon: ImageResource)? {
        guard let status else { return nil }
        switch status {
        case .overdue: return ("Overdue", .icReportFill)
        case .dueSoon: return ("Due Soon", .icWarningFill)
        case .ok: return ("In Progress", .icSchedule)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                chips
                remainingCard
                if let reason {
                    reasonCard(reason)
                }
                if let lastDate = maintenance.lastServiceDay {
                    lastCompletedCard(date: lastDate, distance: maintenance.lastServiceKM)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 16)
        }
        .scrollIndicators(.hidden)
        .background(.svSurface)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    private var header: some View {
        HStack(spacing: 12) {
            if let icon {
                IconCircleView(
                    icon: icon,
                    foreground: .svOnTertiaryContainer,
                    background: .svTertiaryFixed,
                    diameter: 40,
                    iconSize: 20
                )
            }
            VStack(alignment: .leading, spacing: 0) {
                Text(maintenance.name.uppercased())
                    .font(.svHeadlineMobile)
                    .foregroundStyle(.svOnSurface)
                    .accessibilityAddTraits(.isHeader)
                Text("Factory Recommended Interval")
                    .font(.svLabel)
                    .foregroundStyle(.svOnSurfaceVariant)
            }
            Spacer(minLength: 8)
            Button {
                dismiss()
            } label: {
                IconCircleView(icon: .icClose, diameter: 40, iconSize: 18)
            }
            .accessibilityLabel("Close")
        }
    }

    private var chips: some View {
        FlowChips {
            chip("Every \(maintenance.intervalKM.formatted()) km", icon: .icSpeed)
            if maintenance.intervalMonths > 0 {
                chip("Every \(maintenance.intervalMonths) mo", icon: .icCalendarToday)
            }
        }
    }

    private func chip(_ text: String, icon: ImageResource) -> some View {
        BadgeView(
            text: text,
            image: icon,
            textFont: .svLabel,
            textColor: .svOnSurface,
            imageColor: .svOnSurfaceVariant,
            backgroundColor: .svSurfaceHigh,
            verticalPadding: 6
        )
    }

    private var remainingCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text((remainingDays ?? 0) < 0 ? "OVERDUE BY" : "REMAINING UNTIL DUE")
                    .font(.svLabel)
                    .tracking(1.2)
                    .foregroundStyle(.svOnSurfaceVariant)
                Spacer()
                if let statusBadge {
                    BadgeView(
                        text: statusBadge.text,
                        image: statusBadge.icon,
                        textFont: .svLabel,
                        textColor: status?.badgeForegroundColor ?? .svOnSurfaceVariant,
                        imageColor: status?.badgeForegroundColor ?? .svOnSurfaceVariant,
                        backgroundColor: status?.badgeBackgroundColor ?? .svSurfaceHigh,
                        verticalPadding: 3,
                        horizontalPadding: 10
                    )
                }
            }
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text(remainingValue)
                    .font(.svDisplay)
                    .foregroundStyle(status?.progressColor ?? .svOnSurface)
                Text(remainingUnit)
                    .font(.svTitle)
                    .foregroundStyle(.svOnSurfaceVariant)
            }
            if let due = maintenance.dueDate {
                Text("Estimated due by \(due.formatted(.dateTime.month(.wide).day().year()))")
                    .font(.svBodySm)
                    .foregroundStyle(.svOnSurfaceVariant)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.svSurfaceContainer, in: RoundedRectangle(cornerRadius: 20))
        .accessibilityElement(children: .combine)
    }

    private func reasonCard(_ reason: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(.icInfo)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 18, height: 18)
                    .foregroundStyle(.svTertiary)
                Text("Why this service matters")
                    .font(.svTitle)
                    .foregroundStyle(.svOnSurface)
            }
            Text(reason)
                .font(.svBody)
                .foregroundStyle(.svOnSurfaceVariant)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.svSurfaceLow, in: RoundedRectangle(cornerRadius: 20))
    }

    private func lastCompletedCard(date: Date, distance: Int?) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("LAST COMPLETED")
                    .font(.svLabel)
                    .tracking(1.2)
                    .foregroundStyle(.svOnSurfaceVariant)
                Spacer()
            }
            HStack(spacing: 12) {
                IconCircleView(icon: .icHistory, diameter: 40, iconSize: 18)
                Text(lastCompletedText(date: date, distance: distance))
                    .font(.svBody)
                    .bold()
                    .foregroundStyle(.svOnSurface)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.svSurfaceContainer, in: RoundedRectangle(cornerRadius: 20))
    }

    private func lastCompletedText(date: Date, distance: Int?) -> String {
        let day = date.formatted(.dateTime.month(.abbreviated).day().year())
        guard let distance else { return day }
        return "\(day) at \(distance.formatted()) km"
    }
}

private struct FlowChips<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 8) { content }
            ChipFlowLayout(spacing: 8) { content }
        }
    }
}

private struct ChipFlowLayout: Layout {
    var spacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        arrange(in: proposal.width ?? .infinity, subviews: subviews).size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(in: bounds.width, subviews: subviews)
        for (index, origin) in result.origins.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + origin.x, y: bounds.minY + origin.y),
                proposal: .unspecified
            )
        }
    }

    private func arrange(in width: CGFloat, subviews: Subviews) -> (origins: [CGPoint], size: CGSize) {
        var origins: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxX: CGFloat = 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x > 0, x + size.width > width {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            origins.append(CGPoint(x: x, y: y))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            maxX = max(maxX, x - spacing)
        }
        return (origins, CGSize(width: maxX, height: y + rowHeight))
    }
}

#Preview {
    if let maintenance = CarModel.samples.first?.maintenance.first {
        ScheduleDetailSheet(maintenance: maintenance, icon: maintenance.serviceIcon)
    }
}
