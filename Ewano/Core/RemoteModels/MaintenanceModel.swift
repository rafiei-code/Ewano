//
//  MaintenanceModel.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/28.
//

import Foundation

struct MaintenanceModel: Codable, Hashable {
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
    /// Not part of the API: the car's current odometer, set by `UserDataStore` so progress can count kilometres too.
    var currentOdometerKM: Int?

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

extension MaintenanceModel {
    // Items that don't apply to an engine (spark plugs on an electric car) come back with null intervals.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        name = try container.decode(String.self, forKey: .name)
        notes = try container.decodeIfPresent(String.self, forKey: .notes)
        description = try container.decode(String.self, forKey: .description)
        intervalKM = try container.decodeIfPresent(Int.self, forKey: .intervalKM) ?? 0
        applicability = try container.decode(String.self, forKey: .applicability)
        intervalMonths = try container.decodeIfPresent(Int.self, forKey: .intervalMonths) ?? 0
        lastServiceKM = try container.decodeIfPresent(Int.self, forKey: .lastServiceKM)
        scheduleStatus = try container.decode(String.self, forKey: .scheduleStatus)
        lastServiceDate = try container.decodeIfPresent(String.self, forKey: .lastServiceDate)
        maintenanceTypeID = try container.decode(Int.self, forKey: .maintenanceTypeID)
    }
}
