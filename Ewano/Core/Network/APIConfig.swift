//
//  APIConfig.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import Foundation

enum APIConfig {
    // Placeholder until the real backend exists.
    static let baseURL = URL(string: "https://api.pooyan-dev.com")!

    /// The iOS OAuth client ID from Google Cloud Console (APIs & Services → Credentials, type "iOS",
    /// bundle ID com.bcom.ewn.production.Ewano), e.g. "1234-abcd.apps.googleusercontent.com".
    /// Google sign-in shows "not set up" until it's filled in.
    static let googleClientID = ""
}
