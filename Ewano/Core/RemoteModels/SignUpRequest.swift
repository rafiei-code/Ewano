//
//  SignUpRequest.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Foundation

struct SignUpRequest: Encodable {
    let fullname: String
    let username: String
    let password: String
    let email: String
}
