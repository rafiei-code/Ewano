//
//  SchedulePageView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import SwiftUI

struct SchedulePageView: View {
    let user: UserModel
    let car: Car?
    let onNotifications: () -> Void
    let onProfile: () -> Void
    let onSelectService: (ScheduleModel) -> Void

    @State private var selectedCarID: String?
    @State private var filter: ScheduleFilter = .allGood

    init(
        user: UserModel,
        car: Car? = nil,
        onNotifications: @escaping () -> Void = {},
        onProfile: @escaping () -> Void = {},
        onSelectService: @escaping (ScheduleModel) -> Void = { _ in }
    ) {
        self.user = user
        self.car = car
        self.onNotifications = onNotifications
        self.onProfile = onProfile
        self.onSelectService = onSelectService
        let preferred = user.cars.first { $0.isSelected == true } ?? user.cars.first
        _selectedCarID = State(initialValue: preferred?.id)
    }

    private var selectedCar: Car? {
        user.cars.first { $0.id == selectedCarID }
    }

    private var items: [ScheduleItem] {
        (selectedCar?.schedules ?? [])
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
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                titleRow
                    .padding(.top, 8)
                    .padding(.bottom, 16)

                if selectedCar == nil {
                    StateMessageView(
                        kind: .empty,
                        icon: .icDirectionsCar,
                        title: "No vehicles yet",
                        message: "Add a car to see its service schedule."
                    )
                    .padding(.top, 40)
                } else {
                    UnderlineTabBar(items: ScheduleFilter.allCases, selection: $filter) {
                        "\($0.title) (\(count($0.status)))"
                    }
                    .padding(.bottom, 12)

                    summaryChips
                        .padding(.bottom, 20)

                    serviceList
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .background(.svSurface)
        .safeAreaInset(edge: .top, spacing: 0) {
            AppHeaderView(
                profileImageURL: user.profileImageURL,
                onNotifications: onNotifications,
                onProfile: onProfile
            )
        }
    }

    private var titleRow: some View {
        HStack {
            HStack(spacing: 4) {
                Text("SCHEDULE")
                    .foregroundStyle(.svOnSurface)
                    .accessibilityAddTraits(.isHeader)
                Text("✱")
                    .foregroundStyle(.svTertiaryContainer)
                    .accessibilityHidden(true)
            }
            .font(.svHeadlineMobile)

            Spacer(minLength: 12)

            VehicleSwitcher(cars: user.cars, selectedCarID: $selectedCarID)
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
        // Bleeds past the page padding so chips scroll to the screen edges.
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
                        title: item.schedule.title,
                        interval: item.interval,
                        onTap: { onSelectService(item.schedule) }
                    )
                }
            }
            .animation(.spring(response: 0.25, dampingFraction: 0.85), value: filter)
            .animation(.spring(response: 0.25, dampingFraction: 0.85), value: selectedCarID)
        }
    }
}

private struct ScheduleItem: Identifiable {
    let schedule: ScheduleModel
    let interval: ServiceInterval
    let status: ServiceStatus?

    var id: String { schedule.id }

    init(_ schedule: ScheduleModel) {
        self.schedule = schedule
        interval = .distance(interval: schedule.serviceInterval, driven: schedule.accumulatedDistance, unit: .miles)
        status = interval.status
    }

    var sortRank: Int {
        switch status {
        case .overdue: 0
        case .dueSoon: 1
        case .ok: 2
        case nil: 3
        }
    }

    var elapsedFraction: Double {
        schedule.serviceInterval > 0 ? schedule.accumulatedDistance / schedule.serviceInterval : 0
    }

    // ScheduleModel has no service type yet, so the glyph is picked from the title.
    var icon: ImageResource? {
        let title = schedule.title.lowercased()
        let icons: [(String, ImageResource)] = [
            ("coolant", .icModeFanFill),
            ("oil", .icOilBarrelFill),
            ("brake", .icMinorCrashFill),
            ("spark", .icElectricBoltFill),
            ("transmission", .icSettingsSuggestFill),
            ("tire", .icTireRepairFill),
            ("air", .icAirFill)
        ]
        return icons.first { title.contains($0.0) }?.1
    }
}

#Preview {
    SchedulePageView(user: .sample)
}
