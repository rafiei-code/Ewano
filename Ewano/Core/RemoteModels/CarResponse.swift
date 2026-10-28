//
//  CarResponse.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/28.
//

import Foundation

struct CarResponse: Decodable {
    let id: Int
    let manufacturerID: Int
    let name: String
    let imageURL: String
    let imageSourceURL: String
    let sourceURL: String
    let notes: String

    enum CodingKeys: String, CodingKey {
        case id
        case manufacturerID = "manufacturer_id"
        case name
        case imageURL = "image_url"
        case imageSourceURL = "image_source_url"
        case sourceURL = "source_url"
        case notes
    }
}
