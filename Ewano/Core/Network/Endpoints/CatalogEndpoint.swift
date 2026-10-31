//
//  CatalogEndpoint.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Foundation

enum CatalogEndpoint: Endpoint {
    case manufacturers
    case manufacturer(id: Int)
    case models(manufacturerID: Int)
    case engines(modelID: Int)
    case engineMaintenance(engineID: Int)

    var path: String {
        switch self {
        case .manufacturers: "manufacturers"
        case let .manufacturer(id): "manufacturers/\(id)"
        case let .models(manufacturerID): "manufacturers/\(manufacturerID)/models"
        case let .engines(modelID): "models/\(modelID)/engines"
        case let .engineMaintenance(engineID): "engines/\(engineID)/maintenance"
        }
    }
}
