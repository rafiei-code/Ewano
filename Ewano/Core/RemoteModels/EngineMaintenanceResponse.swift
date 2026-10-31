//
//  EngineMaintenanceResponse.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Foundation

struct EngineMaintenanceResponse: Decodable {
    let engine: EngineSummary
    let maintenance: [EngineMaintenanceItem]
}

struct EngineSummary: Decodable {
    let id: Int
    let modelID: Int
    let name: String
    let fuelType: String
    let modelName: String
    let manufacturerID: Int
    let manufacturerName: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case modelID = "model_id"
        case fuelType = "fuel_type"
        case modelName = "model_name"
        case manufacturerID = "manufacturer_id"
        case manufacturerName = "manufacturer_name"
    }
}

struct EngineMaintenanceItem: Decodable {
    let id: Int
    let engineID: Int
    let code: String
    let name: String
    let description: String
    let applicability: String
    let intervalKM: Int?
    let intervalMonths: Int?
    let scheduleStatus: String

    enum CodingKeys: String, CodingKey {
        case id, code, name, description, applicability
        case engineID = "engine_id"
        case intervalKM = "interval_km"
        case intervalMonths = "interval_months"
        case scheduleStatus = "schedule_status"
    }
}
