//
//  CarModel.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/27.
//

import Foundation

struct CarModel: Codable, Equatable, Hashable {
    let id: String
    let name: String
    let nickname: String?
    let imageURL: String
    let isSelected: Bool?
    let carManufacturingYears: [CarManufacturingYearModel]
    let schedules: [ScheduleModel]
    let currentOdometer: String
}
