//
//  CarOdometerStore.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/11/01.
//

import Foundation

/// Each car's current odometer in km. The API has no field for it yet (a car-level `current_km` is requested),
/// so it's kept on this device. Without it, the highest odometer from the car's service records is used.
enum CarOdometerStore {
    private static func key(forCarID carID: Int) -> String {
        "currentOdometer.\(carID)"
    }

    static func kilometers(for car: CarModel) -> Int? {
        let stored = UserDefaults.standard.object(forKey: key(forCarID: car.id)) as? Int
        return stored ?? car.maintenance.compactMap(\.lastServiceKM).max()
    }

    static func save(_ kilometers: Int, forCarID carID: Int) {
        UserDefaults.standard.set(kilometers, forKey: key(forCarID: carID))
    }
}
