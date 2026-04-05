//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct NotificationSettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @AppStorage("appointmentReminders") private var appointmentReminders = true
    @AppStorage("weeklyCheckIn") private var weeklyCheckIn = true

    @State private var authorizationStatus: UNAuthorizationStatus = .notDetermined
    @State private var showingPermissionAlert = false


    var body: some View {
        List {
            statusSection
            if notificationsEnabled {
                preferencesSection
            }
            infoSection
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .task { await checkStatus() }
        .onChange(of: notificationsEnabled) { _, enabled in
            Task { await handleToggle(enabled) }
        }
        .onChange(of: weeklyCheckIn) { _, enabled in
            Task { await handleWeeklyCheckInToggle(enabled) }
        }
        .alert("Notifications Disabled", isPresented: $showingPermissionAlert) {
            Button("Open Settings") { openSettings() }
            Button("Cancel", role: .cancel) { notificationsEnabled = false }
        } message: {
            Text(permissionAlertMessage)
        }
    }

    private var permissionAlertMessage: String {
        "Notifications are disabled in your device settings. "
        + "Open Settings to enable them for OncoWell."
    }

    private var statusSection: some View {
        Section {
            Toggle(isOn: $notificationsEnabled) {
                Label("Enable Notifications", systemImage: "bell.fill")
            }
        } footer: {
            Text("Get gentle reminders before appointments and optional weekly check-ins.")
        }
    }

    private var preferencesSection: some View {
        Section("Preferences") {
            Toggle(isOn: $appointmentReminders) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Appointment Reminders")
                    Text("24 hours before each appointment")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Toggle(isOn: $weeklyCheckIn) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Weekly Check-In")
                    Text("Sunday at 10:00 AM")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var infoSection: some View {
        Section {
            HStack(spacing: 8) {
                Image(systemName: "info.circle")
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
                Text(infoText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var infoText: String {
        "OncoWell sends at most 2 notifications per week. "
        + "All notifications are scheduled locally on your device."
    }

    private func checkStatus() async {
        authorizationStatus = await NotificationService.currentAuthorizationStatus()
        if authorizationStatus != .authorized {
            notificationsEnabled = false
        }
    }

    private func handleToggle(_ enabled: Bool) async {
        if enabled {
            let currentStatus = await NotificationService.currentAuthorizationStatus()
            if currentStatus == .denied {
                showingPermissionAlert = true
                return
            }

            let granted = await NotificationService.requestAuthorization()
            if granted {
                await scheduleIfNeeded()
            } else {
                notificationsEnabled = false
            }
        } else {
            NotificationService.cancelWeeklyCheckIn()
        }
    }

    private func handleWeeklyCheckInToggle(_ enabled: Bool) async {
        if enabled && notificationsEnabled {
            await NotificationService.scheduleWeeklyCheckIn()
        } else {
            NotificationService.cancelWeeklyCheckIn()
        }
    }

    private func scheduleIfNeeded() async {
        if weeklyCheckIn {
            await NotificationService.scheduleWeeklyCheckIn()
        }
    }

    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(url)
    }
}


#Preview {
    NavigationStack {
        NotificationSettingsView()
    }
}
