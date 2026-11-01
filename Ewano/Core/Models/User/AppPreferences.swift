//
//  AppPreferences.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/11/01.
//

import Foundation

/// `UserDefaults` keys for settings that live only on this device.
enum AppPreferences {
    static let prefersMilesKey = "prefersMiles"
    static let serviceAlertsKey = "serviceAlertsEnabled"
    static let overdueAlertsDismissedKey = "overdueAlertsDismissed"
}
