//
//  MaintenanceModel+Service.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import SwiftUI

extension MaintenanceModel {
    var lastServiceDay: Date? {
        lastServiceDate.flatMap(Date.init(apiDay:))
    }

    var dueDate: Date? {
        guard let lastServiceDay, intervalMonths > 0 else { return nil }
        return Calendar.current.date(byAdding: .month, value: intervalMonths, to: Calendar.current.startOfDay(for: lastServiceDay))
    }

    /// Time since the last service or kilometres since it, whichever is further along, so the service is due at whichever comes first.
    var serviceInterval: ServiceInterval {
        [timeInterval, distanceInterval]
            .compactMap { $0 }
            .max { ($0.progress ?? 0) < ($1.progress ?? 0) }
            ?? .distance(interval: intervalKM, driven: 0)
    }

    private var timeInterval: ServiceInterval? {
        guard let lastServiceDay, intervalMonths > 0 else { return nil }
        return .time(interval: intervalMonths, unit: .months, lastService: lastServiceDay)
    }

    private var distanceInterval: ServiceInterval? {
        guard intervalKM > 0, let lastServiceKM, let currentOdometerKM else { return nil }
        return .distance(interval: intervalKM, driven: max(currentOdometerKM - lastServiceKM, 0))
    }

    var serviceStatus: ServiceStatus? {
        serviceInterval.status
    }

    var elapsedFraction: Double {
        serviceInterval.progress ?? 0
    }

    var serviceIcon: ImageResource? {
        let name = name.lowercased()
        let icons: [(String, ImageResource)] = [
            ("coolant", .icModeFanFill),
            ("oil", .icOilBarrelFill),
            ("brake", .icMinorCrashFill),
            ("spark", .icElectricBoltFill),
            ("transmission", .icSettingsSuggestFill),
            ("tire", .icTireRepairFill),
            ("air", .icAirFill)
        ]
        return icons.first { name.contains($0.0) }?.1
    }
}
