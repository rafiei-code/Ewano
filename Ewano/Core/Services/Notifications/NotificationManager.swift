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

    /// The number on the bell and the app icon: the overdue services, or 0 while alerts are switched off or cleared.
    @Published private(set) var badgeCount = 0
    /// True after the user clears the overdue alerts. It stays cleared, across launches, until the next login.
    @Published private(set) var isDismissed = UserDefaults.standard.bool(forKey: AppPreferences.overdueAlertsDismissedKey) {
        didSet { UserDefaults.standard.set(isDismissed, forKey: AppPreferences.overdueAlertsDismissedKey) }
    }
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

    /// A new login brings the alerts back if anything is still overdue.
    func startNewSession() {
        isDismissed = false
    }

    /// Posts one notification listing the overdue services, replacing any earlier one, and updates the badge.
    func notifyOverdueServices(in cars: [CarModel]) async {
        await updateBadge(for: cars)
        let overdue = cars.filter { !$0.overdueMaintenance.isEmpty }
        guard badgeCount > 0, await isAuthorized() else { return }

        let content = UNMutableNotificationContent()
        content.title = badgeCount == 1 ? "1 service is overdue" : "\(badgeCount) services are overdue"
        content.body = Self.summary(of: overdue)
        content.sound = .default
        content.badge = NSNumber(value: badgeCount)

        center.removeDeliveredNotifications(withIdentifiers: [Self.overdueRequestID])
        try? await center.add(UNNotificationRequest(identifier: Self.overdueRequestID, content: content, trigger: nil))
    }

    func updateBadge(for cars: [CarModel]) async {
        let overdueCount = cars.reduce(0) { $0 + $1.overdueMaintenance.count }
        badgeCount = alertsEnabled && !isDismissed ? overdueCount : 0
        await setAppBadge(badgeCount)
    }

    /// Removes the delivered alert and both badges until the next login.
    func dismissAlerts() async {
        isDismissed = true
        badgeCount = 0
        center.removeAllDeliveredNotifications()
        await setAppBadge(0)
    }

    /// The notifications are summaries of what's on the page, so they're cleared once the user has seen it.
    func removeDeliveredNotifications() {
        center.removeAllDeliveredNotifications()
    }

    func clear() async {
        badgeCount = 0
        isDismissed = false
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
