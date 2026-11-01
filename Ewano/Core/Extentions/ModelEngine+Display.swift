//
//  ModelEngine+Display.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import SwiftUI

extension ModelEngine {
    var fuelDescription: String {
        switch fuelType {
        case "petrol": "Petrol"
        case "diesel": "Diesel"
        case "hybrid": "Hybrid"
        case "plug_in_hybrid": "Plug-in hybrid"
        case "electric": "Electric"
        default: fuelType.replacingOccurrences(of: "_", with: " ").capitalized
        }
    }

    var fuelIcon: ImageResource {
        switch fuelType {
        case "hybrid", "plug_in_hybrid", "electric": .icElectricBoltFill
        default: .icLocalGasStationFill
        }
    }
}
