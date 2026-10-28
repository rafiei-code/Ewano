//
//  Manufacturer.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/28.
//

import Foundation

struct Manufacturer: Decodable {
    let id: Int
    let name: String
    let iconURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case iconURL = "icon_url"
    }
}
