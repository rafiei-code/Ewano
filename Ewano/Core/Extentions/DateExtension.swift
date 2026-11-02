//
//  DateExtension.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/11/01.
//

import Foundation

extension Date {
    /// The API's "yyyy-MM-dd" days are read and written in the user's time zone, so the day never shifts.
    private static let apiDayFormat = Date.ISO8601FormatStyle(timeZone: .current).year().month().day()

    init?(apiDay: String) {
        guard let date = try? Date(apiDay, strategy: Self.apiDayFormat) else { return nil }
        self = date
    }

    var apiDay: String {
        formatted(Self.apiDayFormat)
    }
}
