//
//  ScheduleDetailSheet.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/29.
//

import SwiftUI

struct ScheduleDetailSheet: View {
    let schedule: ScheduleModel
    let icon: ImageResource?
    var onRemindLater: () -> Void = {}
    var onMarkAsDone: () -> Void = {}

    @Environment(\.dismiss) private var dismiss

    private var interval: ServiceInterval {
        .distance(interval: schedule.serviceInterval, driven: schedule.accumulatedDistance, unit: .miles)
    }

    private var status: ServiceStatus? {
        interval.status
    }

    private var remaining: Double {
        schedule.serviceInterval - schedule.accumulatedDistance
    }

    private var remainingValue: String {
        abs(remaining).formatted(.number.precision(.fractionLength(0)))
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
                if let reason = schedule.reason {
                    reasonCard(reason)
                }
                if let last = schedule.lastCompleted {
                    lastCompletedCard(last)
                }
                actions
                    .padding(.top, 8)
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
                Text(schedule.title.uppercased())
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
        let distance = "Every \(schedule.serviceInterval.formatted(.number.precision(.fractionLength(0)))) mi"
        return FlowChips {
            chip(distance, icon: .icSpeed)
            if let months = schedule.timeIntervalMonths {
                chip("Every \(months) mo", icon: .icCalendarToday)
            }
            if let cost = schedule.averageCost {
                chip("~$\(cost) avg cost", icon: .icPayments)
            }
            if let difficulty = schedule.difficulty {
                chip(difficulty, icon: .icBuild)
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
                Text(remaining < 0 ? "OVERDUE BY" : "REMAINING UNTIL DUE")
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
                Text("MI")
                    .font(.svTitle)
                    .foregroundStyle(.svOnSurfaceVariant)
            }
            if let due = schedule.estimatedDueDate {
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

    private func lastCompletedCard(_ last: ScheduleModel.LastCompleted) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("LAST COMPLETED")
                    .font(.svLabel)
                    .tracking(1.2)
                    .foregroundStyle(.svOnSurfaceVariant)
                Spacer()
                if last.isCertified {
                    BadgeView(
                        text: "Toyota Certified",
                        image: .icVerifiedFill,
                        textFont: .svLabel,
                        textColor: .svOnTertiaryFixed,
                        imageColor: .svOnTertiaryFixed,
                        backgroundColor: .svTertiaryFixed,
                        verticalPadding: 3,
                        horizontalPadding: 10
                    )
                }
            }
            HStack(spacing: 12) {
                IconCircleView(icon: .icHistory, diameter: 40, iconSize: 18)
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(last.date.formatted(.dateTime.month(.abbreviated).day().year())) at \(last.distance.formatted(.number.precision(.fractionLength(0)))) mi")
                        .font(.svBody)
                        .bold()
                        .foregroundStyle(.svOnSurface)
                    Text(last.provider)
                        .font(.svBodySm)
                        .foregroundStyle(.svOnSurfaceVariant)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.svSurfaceContainer, in: RoundedRectangle(cornerRadius: 20))
    }

    private var actions: some View {
        HStack(spacing: 12) {
            Button {
                onRemindLater()
                dismiss()
            } label: {
                Text("Remind Later")
                    .font(.svTitle)
                    .foregroundStyle(.svOnSurface)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(.svSurfaceHigh, in: RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.pressable)

            Button {
                onMarkAsDone()
                dismiss()
            } label: {
                HStack(spacing: 6) {
                    Text("Mark as Done")
                    Image(.icCheck)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 18, height: 18)
                }
                .font(.svTitle)
                .foregroundStyle(.svOnTertiaryContainer)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(.svTertiaryFixedDim, in: RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.pressable)
        }
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
    ScheduleDetailSheet(
        schedule: .init(
            id: "coolant",
            title: "Coolant Change",
            accumulatedDistance: 27000,
            serviceInterval: 30000,
            timeIntervalMonths: 24,
            averageCost: 90,
            difficulty: "Moderate",
            reason: "Engine coolant prevents overheating in summer and freezing in winter, while lubricating the water pump and protecting aluminum engine components from galvanic corrosion.",
            estimatedDueDate: .now.addingTimeInterval(60 * 60 * 24 * 120),
            lastCompleted: .init(date: .now, distance: 21250, provider: "Downtown Toyota Certified Care Center", isCertified: true)
        ),
        icon: .icModeFanFill
    )
}
