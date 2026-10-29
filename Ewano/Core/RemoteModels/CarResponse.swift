//
//  CarResponse.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/28.
//

import Foundation

import Foundation

struct CarModel: Codable {
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
        case id
        case userID = "user_id"
        case name
        case manufacturerID = "manufacturer_id"
        case manufacturer
        case modelID = "model_id"
        case model
        case engineID = "engine_id"
        case engine
        case imageURL = "image_url"
        case imageSourceURL = "image_source_url"
        case maintenance
    }
}
