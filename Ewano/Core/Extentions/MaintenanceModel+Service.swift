//
//  MaintenanceModel+Service.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import SwiftUI

extension MaintenanceModel {
    private var lastServiceDay: Date? {
        lastServiceDate.flatMap { try? Date($0, strategy: .iso8601.year().month().day()) }
    }

    var serviceInterval: ServiceInterval {
        if let lastServiceDay, intervalMonths > 0 {
            return .time(interval: intervalMonths, unit: .months, lastService: lastServiceDay)
        }
        return .distance(interval: intervalKM, driven: 0)
    }

    var serviceStatus: ServiceStatus? {
        serviceInterval.status
    }

    var elapsedFraction: Double {
        guard let lastServiceDay, intervalMonths > 0 else { return 0 }
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: lastServiceDay)
        guard let due = calendar.date(byAdding: .month, value: intervalMonths, to: start) else { return 0 }
        let total = due.timeIntervalSince(start)
        return total > 0 ? Date.now.timeIntervalSince(start) / total : 0
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
