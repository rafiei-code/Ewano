//
//  SaveMaintenanceRequest.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Foundation

struct SaveMaintenanceRequest: Encodable {
    let maintenance: [Entry]

    struct Entry: Encodable {
        let maintenanceTypeID: Int
        let lastServiceDate: String?
        let lastServiceKM: Int?
        let notes: String?

        enum CodingKeys: String, CodingKey {
            case notes
            case maintenanceTypeID = "maintenance_type_id"
            case lastServiceDate = "last_service_date"
            case lastServiceKM = "last_service_km"
        }
    }
}
