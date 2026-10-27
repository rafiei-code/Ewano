//
//  ScheduleModel.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/27.
//

import Foundation

struct ScheduleModel: Codable {
    let id: String
    let title: String
    var accumulatedDistance: Double
    let serviceInterval: Double
}
