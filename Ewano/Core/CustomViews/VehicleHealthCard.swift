//
//  VehicleHealthCard.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import SwiftUI

struct VehicleHealthCard: View {

    let car: Car
    var footerMessage: String?
    var onTapSchedule: (() -> Void)?

    private var imageURL: String? {
        if !car.imageURL.isEmpty {
            return car.imageURL
        }

        let fallback = car.carManufacturingYears.first?.carImageURl ?? ""
        return fallback.isEmpty ? nil : fallback
    }

    private var overdueSchedules: [ScheduleModel] {
        car.schedules.filter {
            $0.serviceInterval > 0 && $0.accumulatedDistance >= $0.serviceInterval
        }
    }

    private var nextSchedule: ScheduleModel? {
        car.schedules
            .filter { $0.serviceInterval > 0 }
            .min { remainingFraction(of: $0) < remainingFraction(of: $1) }
    }

    private var resolvedFooterMessage: String? {
        if let footerMessage {
            return footerMessage
        }
        if let overdue = overdueSchedules.first {
            return "\(overdue.title) overdue"
        }
        return nextSchedule.map { "\($0.title) upcoming" }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            if let imageURL {
                HStack {
                    Spacer()
                    withAnimation {
                        AppImage(type: .url(car.imageURL))
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .background(.svSurfaceContainer, in: RoundedRectangle(cornerRadius: 16))
                            .accessibilityHidden(true)
                            .frame(minHeight: 100)
                            .padding()
                    }
                    Spacer()
                }
            }

            Rectangle()
                .fill(.svOutlineVariant.opacity(0.6))
                .frame(height: 1)

            metrics

            Rectangle()
                .fill(.svOutlineVariant.opacity(0.6))
                .frame(height: 1)

            if let resolvedFooterMessage {
                footer(resolvedFooterMessage)
                    .padding(12)
            }
        }
        .background(alignment: .topTrailing) { glow }
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .cardSurface(cornerRadius: 24)
        .accessibilityElement(children: .contain)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(VehicleSwitcher.displayName(car))
                .font(.svTitle)
                .foregroundStyle(.svOnSurface)
                .lineLimit(1)

            if let nickname = car.nickname {
                Text(nickname)
                    .font(.svBodySm)
                    .foregroundStyle(.svOnSurfaceVariant)
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }

    private var metrics: some View {
        HStack(spacing: 14) {
            metric(
                title: "MILEAGE",
                value: car.currentOdometer,
                icon: .icSpeed,
                valueColor: .svOnSurface
            )

            Rectangle()
                .fill(.svOutlineVariant.opacity(0.6))
                .frame(width: 1, height: 36)
                .accessibilityHidden(true)

            metric(
                title: "NEXT DUE",
                value: nextSchedule?.title ?? "—",
                icon: .icWaterDropFill,
                valueColor: .svOnTertiaryContainer
            )

            Spacer(minLength: 8)

            if !overdueSchedules.isEmpty {
                BadgeView(
                    text: "\(overdueSchedules.count) Overdue",
                    image: .icWarningFill,
                    textFont: .svLabel,
                    textColor: .svOnErrorContainer,
                    imageColor: .svOnErrorContainer,
                    backgroundColor: .svErrorContainer,
                    verticalPadding: 6,
                    horizontalPadding: 10
                )
                .fixedSize()
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    private func metric(
        title: String,
        value: String,
        icon: ImageResource,
        valueColor: Color
    ) -> some View {
        HStack(spacing: 10) {
            IconCircleView(
                icon: icon,
                foreground: .svTertiary,
                background: .svSurfaceContainer,
                diameter: 38,
                iconSize: 20
            )

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.svLabel)
                    .tracking(1)
                    .foregroundStyle(.svOnSurfaceVariant)
                    .lineLimit(1)

                Text(value)
                    .font(.svTitle)
                    .foregroundStyle(valueColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .accessibilityElement(children: .combine)
    }

    private func footer(_ message: String) -> some View {
        HStack(spacing: 12) {
            Text(message)
                .font(.svBodySm)
                .foregroundStyle(.svOnSurface)
                .lineLimit(1)
                .truncationMode(.tail)

            Spacer(minLength: 8)

            CustomButtonView(
                config: .init(
                    title: "View Schedule",
                    trailingImage: .icChevronRight,
                    trailingImageSize: 16,
                    titleColor: .svOnTertiaryContainer,
                    titleFont: .svLabel,
                    iconColor: .svOnTertiaryContainer,
                    variant: .plain
                )
            ) {
                onTapSchedule?()
            }
            .fixedSize()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.svSurfaceHigh, in: RoundedRectangle(cornerRadius: 14))
    }

    private var glow: some View {
        RadialGradient(
            colors: [Color.svTertiaryFixed.opacity(0.7), Color.svTertiaryFixed.opacity(0)],
            center: .topTrailing,
            startRadius: 0,
            endRadius: 160
        )
        .frame(width: 240, height: 240)
        .offset(x: 70, y: -70)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private func remainingFraction(of schedule: ScheduleModel) -> Double {
        let remaining = (schedule.serviceInterval - schedule.accumulatedDistance) / schedule.serviceInterval
        return min(max(remaining, 0), 1)
    }
}

#Preview {
    ZStack {
        Color.svSurfaceHigh.ignoresSafeArea()

        VehicleHealthCard(
            car: Car(
                id: "1",
                name: "Toyota Camry",
                nickname: "Daily driver",
                imageURL: "",
                isSelected: true,
                carManufacturingYears: [],
                schedules: [
                    .init(id: "1", title: "Coolant Flush", accumulatedDistance: 240, serviceInterval: 300),
                    .init(id: "2", title: "Oil service", accumulatedDistance: 300, serviceInterval: 300)
                ],
                currentOdometer: "48,250"
            ),
            footerMessage: "Oil service 14 days overdue"
        ) {
        }
        .padding()
    }
}
