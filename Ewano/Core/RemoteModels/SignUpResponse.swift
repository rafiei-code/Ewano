//
//  SignUpResponse.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/28.
//

import Foundation

struct SignUpResponse: Decodable {
    let id: Int
    let fullname: String
    let username: String
    let email: String
}
