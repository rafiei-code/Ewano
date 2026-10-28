//
//  ModelEngine.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/28.
//

import Foundation

struct ModelEngine: Decodable {
    let id: Int
    let modelID: Int
    let name: String
    let fuelType: String
    let sourceURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case modelID = "model_id"
        case name
        case fuelType = "fuel_type"
        case sourceURL = "source_url"
    }
}
