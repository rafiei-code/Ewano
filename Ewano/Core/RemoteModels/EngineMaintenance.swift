//
//  EngineMaintenance.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/28.
//

import Foundation

struct EngineMaintenance: Decodable {
    let id: Int
    let engineID: Int
    let code: String
    let name: String
    let description: String
    let applicability: String
    let intervalKM: Int
    let intervalMonths: Int
    let scheduleStatus: String

    enum CodingKeys: String, CodingKey {
        case id
        case engineID = "engine_id"
        case code
        case name
        case description
        case applicability
        case intervalKM = "interval_km"
        case intervalMonths = "interval_months"
        case scheduleStatus = "schedule_status"
    }
}
