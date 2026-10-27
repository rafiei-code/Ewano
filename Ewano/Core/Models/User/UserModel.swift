//
//  UserModel.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/27.
//

import Foundation

struct UserModel: Codable {
    let id: String
    let name: String
    let email: String
    let password: String
    let cars: [CarModel]
}
