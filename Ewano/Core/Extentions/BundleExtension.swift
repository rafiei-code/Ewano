//
//  BundleExtension.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import Foundation

extension Bundle {
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    var buildNumber: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    func decode<T: Decodable>(_ type: T.Type = T.self, fromJSON fileName: String) -> T {
        guard let url = url(forResource: fileName, withExtension: "json") else {
            fatalError("Missing \(fileName).json in the bundle.")
        }
        do {
            return try JSONDecoder().decode(T.self, from: Data(contentsOf: url))
        } catch {
            fatalError("Could not decode \(fileName).json as \(T.self): \(error)")
        }
    }
}
