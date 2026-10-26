//
//  AppRoute.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI

enum AppRoute: Hashable {
    case login

    var colorScheme: ColorScheme {
        switch self {
        case .login: .light
        }
    }
}
