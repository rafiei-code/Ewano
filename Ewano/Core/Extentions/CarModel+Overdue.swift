//
//  CarModel+Overdue.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/11/01.
//

import Foundation

extension CarModel {
    var overdueMaintenance: [MaintenanceModel] {
        maintenance.filter { $0.serviceStatus == .overdue }
    }
}
