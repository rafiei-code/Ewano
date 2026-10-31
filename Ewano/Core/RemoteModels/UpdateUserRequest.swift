//
//  UpdateUserRequest.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Foundation

struct UpdateUserRequest: Encodable {
    var fullname: String?
    var username: String?
    var password: String?
}
