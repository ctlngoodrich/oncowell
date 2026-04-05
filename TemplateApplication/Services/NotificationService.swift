//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import UserNotifications


enum NotificationService {
    struct AppointmentInfo: Sendable {
        let id: Int
        let date: Date
        let typeName: String
        let providerName: String
    }

    private static let appointmentReminderPrefix = "appointment-reminder-"
    private static let weeklyCheckInID = "weekly-check-in"

    static func scheduleAppointmentReminder(info: AppointmentInfo) async {
        let reminderDate = info.date.addingTimeInterval(-24 * 60 * 60)

        guard reminderDate > Date.now else {
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Appointment Tomorrow"
        content.body = appointmentReminderBody(info)
        content.sound = .default

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: reminderDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let identifier = appointmentReminderPrefix + info.id.description

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        try? await UNUserNotificationCenter.current().add(request)
    }

    static func cancelAppointmentReminder(appointmentID: Int) {
        let identifier = appointmentReminderPrefix + appointmentID.description
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    static func scheduleWeeklyCheckIn() async {
        let content = UNMutableNotificationContent()
        content.title = "Weekly Check-In"
        content.body = "How are you feeling this week? Log any symptoms or updates."
        content.sound = .default

        var components = DateComponents()
        components.weekday = 1
        components.hour = 10
        components.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: weeklyCheckInID, content: content, trigger: trigger)
        try? await UNUserNotificationCenter.current().add(request)
    }

    static func cancelWeeklyCheckIn() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [weeklyCheckInID])
    }

    static func requestAuthorization() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    static func currentAuthorizationStatus() async -> UNAuthorizationStatus {
        await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
    }

    private static func appointmentReminderBody(_ info: AppointmentInfo) -> String {
        var body = "Your \(info.typeName.lowercased()) is tomorrow"
        if !info.providerName.isEmpty {
            body += " with \(info.providerName)"
        }
        body += ". Review your questions?"
        return body
    }
}
