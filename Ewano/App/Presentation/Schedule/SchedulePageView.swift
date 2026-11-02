//
//  SchedulePageView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import SwiftUI

struct SchedulePageView: View {
    let user: User
    let userProfile: ProfileResponse
    let cars: [CarModel]
    let onNotifications: () -> Void
    let onProfile: () -> Void
    let onSelectService: (MaintenanceModel) -> Void

    @State private var filter: ScheduleFilter = .allGood
    @ObservedObject private var router = SwitchTabRouter.shared
    @State private var detailItem: ScheduleItem?
    @Environment(\.navigate) private var navigate

    init(
        user: User,
        userProfile: ProfileResponse,
        cars: [CarModel],
        onNotifications: @escaping () -> Void = {},
        onProfile: @escaping () -> Void = {},
        onSelectService: @escaping (MaintenanceModel) -> Void = { _ in }
    ) {
        self.user = user
        self.userProfile = userProfile
        self.cars = cars
        self.onNotifications = onNotifications
        self.onProfile = onProfile
        self.onSelectService = onSelectService
    }

    // The router keeps a copy of the selected car, so it's looked up again to show the latest data after an update.
    private var car: CarModel? {
        router.selectedCar.flatMap { selected in
            cars.first { $0.id == selected.id }
        } ?? cars.first
    }

    private var items: [ScheduleItem] {
        (car?.maintenance ?? [])
            .map(ScheduleItem.init)
            .sorted { lhs, rhs in
                if lhs.sortRank != rhs.sortRank { return lhs.sortRank < rhs.sortRank }
                return lhs.elapsedFraction > rhs.elapsedFraction
            }
    }

    private var filteredItems: [ScheduleItem] {
        guard let status = filter.status else { return items }
        return items.filter { $0.status == status }
    }

    private func count(_ status: ServiceStatus?) -> Int {
        guard let status else { return items.count }
        return items.filter { $0.status == status }.count
    }

    var body: some View {
        VStack {
            AppScreenHeaderView(user: userProfile, onTapProfile: {
                SwitchTabRouter.shared.currentTab = .more
            })
            // Title, filters and counts stay put; only the service list scrolls.
            VStack(alignment: .leading, spacing: 0) {
                titleRow
                    .padding(.top, 8)
                    .padding(.bottom, 16)

                if car != nil {
                    UnderlineTabBar(items: ScheduleFilter.allCases, selection: $filter) {
                        "\($0.title) (\(count($0.status)))"
                    }
                    .padding(.bottom, 12)

                    summaryChips
                        .padding(.bottom, 8)
                }
            }
            .padding(.horizontal, 20)

            ScrollView {
                Group {
                    if car == nil {
                        StateMessageView(
                            kind: .empty,
                            icon: .icDirectionsCar,
                            title: "No vehicle selected",
                            message: "Add a vehicle to see its schedule."
                        )
                        .padding(.top, 40)
                    } else {
                        serviceList
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
        .background(.svSurface)
        .sheet(item: $detailItem) { item in
            ScheduleDetailSheet(
                maintenance: item.maintenance,
                icon: item.icon
            )
        }
    }

    private var selectedCarID: Binding<Int?> {
        Binding(
            get: { car?.id },
            set: { newID in
                if let newCar = cars.first(where: { $0.id == newID }) {
                    router.select(newCar)
                }
            }
        )
    }

    private var titleRow: some View {
        HStack {
            PillButton(title: "Update", icon: .icEdit) {
                if let car { navigate(to: .editMaintenance(car: car)) }
            }
            .disabled(car == nil)
            .accessibilityLabel("Update mileage and service status")
            Spacer(minLength: 8)
            VehicleSwitcher(cars: cars, selectedCarID: selectedCarID)
        }
    }

    private var summaryChips: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(ServiceStatus.allCases, id: \.self) { status in
                    StatusCountChip(
                        color: status.progressColor,
                        title: "\(count(status)) \(ScheduleFilter(status).title)"
                    )
                }
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 20)
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, -20)
    }

    @ViewBuilder
    private var serviceList: some View {
        if filteredItems.isEmpty {
            StateMessageView(
                kind: .empty,
                icon: .icDoneAll,
                title: "Nothing here",
                message: "No \(filter.title.lowercased()) services for this vehicle."
            )
            .padding(.top, 24)
        } else {
            LazyVStack(spacing: 12) {
                ForEach(filteredItems) { item in
                    ServiceStatusRow(
                        icon: item.icon,
                        title: item.maintenance.name,
                        interval: item.interval,
                        onTap: {
                            onSelectService(item.maintenance)
                            detailItem = item
                        }
                    )
                }
            }
            .animation(.spring(response: 0.25, dampingFraction: 0.85), value: filter)
            .animation(.spring(response: 0.25, dampingFraction: 0.85), value: car?.id)
        }
    }
}

private struct ScheduleItem: Identifiable {
    let maintenance: MaintenanceModel
    let interval: ServiceInterval
    let status: ServiceStatus?

    var id: String { maintenance.code }

    init(_ maintenance: MaintenanceModel) {
        self.maintenance = maintenance
        interval = maintenance.serviceInterval
        status = interval.status
    }

    var elapsedFraction: Double { maintenance.elapsedFraction }

    var sortRank: Int {
        switch status {
        case .overdue: 0
        case .dueSoon: 1
        case .ok: 2
        case nil: 3
        }
    }

    var icon: ImageResource? { maintenance.serviceIcon }
}

#Preview {
    SchedulePageView(user: .sample, userProfile: .sample, cars: CarModel.samples)
}
