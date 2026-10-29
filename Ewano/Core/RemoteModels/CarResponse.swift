//
//  CarResponse.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/28.
//

import Foundation

struct CarResponse: Codable {
    let id: Int
    let userID: Int
    let name: String
    let manufacturerID: Int
    let manufacturer: String
    let modelID: Int
    let model: String
    let engineID: Int
    let engine: String
    let imageURL: String
    let imageSourceURL: String
    let maintenance: [MaintenanceModel]

    enum CodingKeys: String, CodingKey {
        case id, name, manufacturer, model, engine, maintenance
        case userID = "user_id"
        case manufacturerID = "manufacturer_id"
        case modelID = "model_id"
        case engineID = "engine_id"
        case imageURL = "image_url"
        case imageSourceURL = "image_source_url"
    }
}
