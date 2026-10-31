//
//  ManufacturerModel.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Foundation

struct ManufacturerModel: Decodable, Hashable {
    let id: Int
    let manufacturerID: Int
    let name: String
    let imageURL: String?
    let imageSourceURL: String?
    let sourceURL: String?
    let notes: String?

    enum CodingKeys: String, CodingKey {
        case id, name, notes
        case manufacturerID = "manufacturer_id"
        case imageURL = "image_url"
        case imageSourceURL = "image_source_url"
        case sourceURL = "source_url"
    }
}
