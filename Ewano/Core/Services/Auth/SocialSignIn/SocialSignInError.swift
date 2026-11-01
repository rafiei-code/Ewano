//
//  SocialSignInError.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/11/01.
//

import UIKit

enum SocialSignInError: LocalizedError {
    case canceled
    case notConfigured
    case failed

    var errorDescription: String? {
        switch self {
        case .canceled: nil
        case .notConfigured: "This sign-in option isn't set up yet."
        case .failed: "Sign-in didn't complete. Please try again."
        }
    }
}

extension UIApplication {
    /// The window the sign-in sheets are shown over.
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)
    }
}
