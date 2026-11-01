//
//  MaintenanceModel+Setup.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/11/01.
//

import Foundation

extension MaintenanceModel {
    var isRequired: Bool {
        applicability == "required"
    }

    var isConditional: Bool {
        applicability == "conditional"
    }

    var hasInterval: Bool {
        intervalKM > 0 || intervalMonths > 0
    }

    func intervalText(in unit: DistanceUnit) -> String {
        let parts = [
            intervalKM > 0 ? unit.formatted(kilometers: intervalKM) : nil,
            intervalMonths > 0 ? "\(intervalMonths) mos" : nil
        ].compactMap { $0 }
        return parts.isEmpty ? "As needed" : "Every " + parts.joined(separator: " / ")
    }
}
