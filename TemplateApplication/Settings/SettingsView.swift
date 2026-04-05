//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftData
import SwiftUI


struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query private var profiles: [PatientProfile]

    @State private var showingProfileEditor = false


    var body: some View {
        NavigationStack {
            List {
                profileSection
                healthSection
                notificationsSection
                dataSection
                aboutSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showingProfileEditor) {
                if let profile = profiles.first {
                    ProfileEditView(profile: profile)
                }
            }
        }
    }

    private var profile: PatientProfile? { profiles.first }

    private var profileSection: some View {
        Section("Profile") {
            if let profile {
                profileSummary(profile)
            } else {
                Text("No profile set up")
                    .foregroundStyle(.secondary)
            }
            Button("Edit Profile") {
                ensureProfile()
                showingProfileEditor = true
            }
        }
    }

    private var healthSection: some View {
        Section {
            Button {
                openHealthSettings()
            } label: {
                HStack {
                    Label("HealthKit Permissions", systemImage: "heart.fill")
                    Spacer()
                    Image(systemName: "arrow.up.forward.app")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .accessibilityHidden(true)
                }
            }
        } header: {
            Text("Health Data")
        } footer: {
            Text("Manage which health data OncoWell can read in iOS Settings.")
        }
    }

    private var notificationsSection: some View {
        Section {
            NavigationLink {
                NotificationSettingsView()
            } label: {
                Label("Notifications", systemImage: "bell.fill")
            }
        }
    }

    private var dataSection: some View {
        Section {
            NavigationLink {
                DataManagementView()
            } label: {
                Label("Manage Data", systemImage: "externaldrive.fill")
            }
        }
    }

    private var aboutSection: some View {
        Section("About") {
            NavigationLink {
                AboutView()
            } label: {
                Label("About OncoWell", systemImage: "info.circle")
            }
            HStack {
                Text("Version")
                Spacer()
                Text(appVersion)
                    .foregroundStyle(.secondary)
            }
            HStack {
                Text("Content Updated")
                Spacer()
                Text("March 2026")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    private func profileSummary(_ profile: PatientProfile) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if !profile.name.isEmpty {
                Text(profile.name)
                    .font(.headline)
            }
            if let cancerType = profile.cancerType {
                Text(cancerType.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            if let stage = profile.cancerStage {
                Text(stage.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            if let status = profile.treatmentStatus {
                Text(status.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func ensureProfile() {
        if profiles.isEmpty {
            modelContext.insert(PatientProfile())
        }
    }

    private func openHealthSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(url)
    }
}


#Preview {
    SettingsView()
        .modelContainer(for: PatientProfile.self, inMemory: true)
}
