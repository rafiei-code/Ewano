//
//  NotificationManager.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/11/01.
//

import Combine
import UIKit
import UserNotifications

/// Local notifications about overdue services, the app icon badge, and opening the notifications page from a tap.
@MainActor
final class NotificationManager: NSObject, ObservableObject {
    static let shared = NotificationManager()

    /// Overdue services across the user's cars, shown on the bell and the app icon.
    @Published private(set) var overdueCount = 0
    /// Set when the user taps an overdue notification. The app opens the notifications page and clears it.
    @Published var opensNotificationsPage = false

    private let center = UNUserNotificationCenter.current()
    private static let overdueRequestID = "overdue-services"

    private var alertsEnabled: Bool {
        UserDefaults.standard.object(forKey: AppPreferences.serviceAlertsKey) as? Bool ?? true
    }

    /// Called at launch so taps on notifications reach the app, even when the tap launches it.
    func activate() {
        center.delegate = self
    }

    /// Posts one notification listing the overdue services, replacing any earlier one, and updates the badge.
    func notifyOverdueServices(in cars: [CarModel]) async {
        await updateBadge(for: cars)
        let overdue = cars.filter { !$0.overdueMaintenance.isEmpty }
        guard alertsEnabled, overdueCount > 0, await isAuthorized() else { return }

        let content = UNMutableNotificationContent()
        content.title = overdueCount == 1 ? "1 service is overdue" : "\(overdueCount) services are overdue"
        content.body = Self.summary(of: overdue)
        content.sound = .default
        content.badge = NSNumber(value: overdueCount)

        center.removeDeliveredNotifications(withIdentifiers: [Self.overdueRequestID])
        try? await center.add(UNNotificationRequest(identifier: Self.overdueRequestID, content: content, trigger: nil))
    }

    func updateBadge(for cars: [CarModel]) async {
        overdueCount = alertsEnabled ? cars.reduce(0) { $0 + $1.overdueMaintenance.count } : 0
        await setAppBadge(overdueCount)
    }

    /// The notifications are summaries of what's on the page, so they're cleared once the user has seen it.
    func removeDeliveredNotifications() {
        center.removeAllDeliveredNotifications()
    }

    func clear() async {
        overdueCount = 0
        opensNotificationsPage = false
        center.removeAllDeliveredNotifications()
        await setAppBadge(0)
    }

    private func isAuthorized() async -> Bool {
        switch await center.notificationSettings().authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return true
        case .notDetermined:
            return (try? await center.requestAuthorization(options: [.alert, .badge, .sound])) ?? false
        default:
            return false
        }
    }

    private func setAppBadge(_ count: Int) async {
        if #available(iOS 17.0, *) {
            try? await center.setBadgeCount(count)
        } else {
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }

    private static func summary(of cars: [CarModel]) -> String {
        var lines = cars.prefix(3).map { car in
            "\(car.manufacturer) \(car.model): " + car.overdueMaintenance.map(\.name).joined(separator: ", ")
        }
        if cars.count > 3 {
            lines.append("and \(cars.count - 3) more cars")
        }
        return lines.joined(separator: "\n")
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .list, .badge, .sound]
    }

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        guard response.notification.request.identifier == Self.overdueRequestID else { return }
        await MainActor.run { opensNotificationsPage = true }
    }
}
