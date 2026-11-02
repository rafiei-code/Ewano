//
//  NotificationsPageView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/11/01.
//

import SwiftUI

struct NotificationsPageView: View {
    @Environment(\.navigate) private var navigate
    @EnvironmentObject private var userData: UserDataStore
    @ObservedObject private var notifications = NotificationManager.shared

    private var carsWithOverdue: [CarModel] {
        userData.cars.filter { !$0.overdueMaintenance.isEmpty }
    }

    private var overdueCount: Int {
        carsWithOverdue.reduce(0) { $0 + $1.overdueMaintenance.count }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if carsWithOverdue.isEmpty {
                    StateMessageView(
                        kind: .empty,
                        icon: .icCheckCircleFill,
                        title: "You're all caught up",
                        message: "None of your cars have overdue services."
                    )
                    .padding(.top, 40)
                } else {
                    if notifications.isDismissed {
                        InfoTipCard(
                            icon: .icDoneAll,
                            title: "Alerts cleared",
                            subtitle: "You'll be reminded at your next login if anything is still overdue.",
                            iconColor: .svOnSurfaceVariant,
                            background: .svSurfaceContainer
                        )
                    } else {
                        InfoTipCard(
                            icon: .icReportFill,
                            title: overdueCount == 1 ? "1 service is overdue" : "\(overdueCount) services are overdue",
                            subtitle: "Tap a service to open its car's schedule.",
                            iconColor: .svError,
                            background: .svErrorContainer.opacity(0.5)
                        )
                    }

                    ForEach(carsWithOverdue, id: \.id) { car in
                        carSection(car)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 40)
        }
        .background(.svSurface)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("NOTIFICATIONS")
                    .font(.svHeadlineMd)
                    .foregroundStyle(.svOnSurface)
                    .fixedSize()
                    .accessibilityAddTraits(.isHeader)
            }
            .hiddenSharedBackground()

            if notifications.badgeCount > 0 {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear") {
                        Task { await notifications.dismissAlerts() }
                    }
                    .font(.svButton)
                    .foregroundStyle(.svTertiary)
                    .accessibilityHint("Removes the overdue alert and badges until your next login")
                }
            }
        }
        .animation(.easeOut(duration: 0.2), value: notifications.isDismissed)
        .onAppear {
            NotificationManager.shared.removeDeliveredNotifications()
        }
    }

    private func carSection(_ car: CarModel) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(car.name)
                    .font(.svTitle)
                    .foregroundStyle(.svOnSurface)
                Text("\(car.manufacturer) \(car.model)")
                    .font(.svLabel)
                    .foregroundStyle(.svOnSurfaceVariant)
                Spacer(minLength: 8)
                Text("\(car.overdueMaintenance.count) overdue")
                    .font(.svLabel)
                    .bold()
                    .foregroundStyle(.svError)
            }
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isHeader)

            ForEach(car.overdueMaintenance, id: \.maintenanceTypeID) { item in
                ServiceStatusRow(
                    icon: item.serviceIcon,
                    title: item.name,
                    interval: item.serviceInterval,
                    layout: .compact,
                    onTap: { openSchedule(for: car) }
                )
            }
        }
    }

    private func openSchedule(for car: CarModel) {
        navigate.popToRoot()
        SwitchTabRouter.shared.showSchedule(for: car)
    }
}

#Preview {
    NavigationStack {
        NotificationsPageView()
    }
    .environmentObject(UserDataStore.shared)
}
