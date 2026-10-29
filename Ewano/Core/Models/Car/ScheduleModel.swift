//
//  ScheduleModel.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/27.
//

import Foundation

struct ScheduleModel: Codable, Equatable, Hashable {
    let id: String
    let title: String
    var accumulatedDistance: Double
    let serviceInterval: Double
    var timeIntervalMonths: Int?
    var averageCost: Int?
    var difficulty: String?
    var reason: String?
    var estimatedDueDate: Date?
    var lastCompleted: LastCompleted?

    struct LastCompleted: Codable, Equatable, Hashable {
        let date: Date
        let distance: Double
        let provider: String
        var isCertified: Bool = false
    }
}
