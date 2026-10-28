//
//  Login.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/28.
//

import Foundation

struct LoginResponse: Decodable {
    let token: String
    let tokenType: String
    let expiresIn: Int
    let user: User
}
