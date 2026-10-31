//
//  User+Sample.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/29.
//

import Foundation

extension User {
    static let sample: User = Bundle.main.decode(fromJSON: "home_user_sample")
}

extension CarModel {
    static let samples: [CarModel] = Bundle.main.decode(fromJSON: "home_cars_sample")
}
