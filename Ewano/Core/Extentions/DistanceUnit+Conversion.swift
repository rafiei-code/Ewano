//
//  DistanceUnit+Conversion.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import Foundation

extension DistanceUnit {
    private static let kilometersPerMile = 1.609344

    func kilometers(from value: Int) -> Int {
        switch self {
        case .kilometers: value
        case .miles: Int((Double(value) * Self.kilometersPerMile).rounded())
        }
    }

    /// Miles are rounded to the nearest hundred so converted intervals stay readable.
    func formatted(kilometers: Int) -> String {
        let value = switch self {
        case .kilometers: kilometers
        case .miles: Int((Double(kilometers) / Self.kilometersPerMile / 100).rounded()) * 100
        }
        return "\(value.formatted()) \(symbol)"
    }
}
