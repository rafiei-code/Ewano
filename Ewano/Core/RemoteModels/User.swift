//
//  User.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/28.
//

import Foundation

struct User: Decodable, Hashable {
    let id: Int
    let fullname: String
    let username: String
}
