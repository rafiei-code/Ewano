//
//  ProfileResponse.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/28.
//

import Foundation

struct ProfileResponse: Decodable {
    let fullname: String
    let email: String?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case fullname
        case email
        case imageURL = "image_url"
    }
}
