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
                    InfoTipCard(
                        icon: .icReportFill,
                        title: overdueCount == 1 ? "1 service is overdue" : "\(overdueCount) services are overdue",
                        subtitle: "Tap a service to open its car's schedule.",
                        iconColor: .svError,
                        background: .svErrorContainer.opacity(0.5)
                    )

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
        }
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
