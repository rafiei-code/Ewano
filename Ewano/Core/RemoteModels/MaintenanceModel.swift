//
//  MaintenanceModel.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/28.
//

import Foundation

struct MaintenanceModel: Codable {
    let code: String
    let name: String
    let notes: String?
    let description: String
    let intervalKM: Int
    let applicability: String
    let intervalMonths: Int
    let lastServiceKM: Int?
    let scheduleStatus: String
    let lastServiceDate: String?
    let maintenanceTypeID: Int

    enum CodingKeys: String, CodingKey {
        case code, name, notes, description, applicability
        case intervalKM = "interval_km"
        case intervalMonths = "interval_months"
        case lastServiceKM = "last_service_km"
        case scheduleStatus = "schedule_status"
        case lastServiceDate = "last_service_date"
        case maintenanceTypeID = "maintenance_type_id"
    }
}
