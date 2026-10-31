//
//  CreateUserCarRequest.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Foundation

struct CreateUserCarRequest: Encodable {
    let manufacturerID: Int
    let modelID: Int
    let engineID: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
        case manufacturerID = "manufacturer_id"
        case modelID = "model_id"
        case engineID = "engine_id"
    }
}
