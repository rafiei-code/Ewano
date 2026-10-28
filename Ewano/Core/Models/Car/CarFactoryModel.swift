//
//  CarFactoryModel.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/27.
//

import Foundation

struct CarFactoryModel: Codable {
    let id: String
    let name: String
    let imageURl: String
    let isSelected: Bool?
    let models: [Car]
}
