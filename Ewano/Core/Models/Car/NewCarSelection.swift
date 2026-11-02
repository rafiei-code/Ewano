//
//  NewCarSelection.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Foundation

struct NewCarSelection: Hashable {
    enum Transmission: String, CaseIterable {
        case automatic = "Automatic"
        case manual = "Manual"
    }

    let manufacturer: Manufacturer
    let model: ManufacturerModel
    let engine: ModelEngine
    let transmission: Transmission

    var title: String {
        "\(manufacturer.name) \(model.name)"
    }
}
