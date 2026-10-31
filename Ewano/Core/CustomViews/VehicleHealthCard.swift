//
//  VehicleHealthCard.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import SwiftUI

struct VehicleHealthCard: View {

    let car: CarModel
    var footerMessage: String?
    var onTapSchedule: (() -> Void)?

    private var imageURL: String? {
        car.imageURL.isEmpty ? nil : car.imageURL
    }

    private var overdueSchedules: [MaintenanceModel] {
        car.maintenance.filter { $0.serviceStatus == .overdue }
    }

    private var nextSchedule: MaintenanceModel? {
        car.maintenance
            .filter { $0.serviceStatus != nil }
            .max { $0.elapsedFraction < $1.elapsedFraction }
    }

    private var mileage: String {
        car.maintenance
            .compactMap(\.lastServiceKM)
            .max()
            .map { $0.formatted() } ?? "—"
    }

    private var resolvedFooterMessage: String? {
        if let footerMessage {
            return footerMessage
        }
        if let overdue = overdueSchedules.first {
            return "\(overdue.name) overdue"
        }
        return nextSchedule.map { "\($0.name) upcoming" }
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
                value: mileage,
                icon: .icSpeed,
                valueColor: .svOnSurface
            )

            Rectangle()
                .fill(.svOutlineVariant.opacity(0.6))
                .frame(width: 1, height: 36)
                .accessibilityHidden(true)

            metric(
                title: "NEXT DUE",
                value: nextSchedule?.name ?? "—",
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

}

#Preview {
    ZStack {
        Color.svSurfaceHigh.ignoresSafeArea()

        if let car = CarModel.samples.first {
            VehicleHealthCard(car: car) {
            }
            .padding()
        }
    }
}
