//
//  UserModel+Sample.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import Foundation

extension UserModel {
    static let sample: UserModel = Bundle.main.decode(fromJSON: "user_sample")
}
