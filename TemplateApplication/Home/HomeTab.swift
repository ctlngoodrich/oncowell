//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziHealthKit
import SwiftData
import SwiftUI


// swiftlint:disable:next file_types_order
struct HomeTab: View {
    @Query(sort: \Appointment.date, order: .forward) private var appointments: [Appointment]
    @Query private var profiles: [PatientProfile]


    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                nextAppointmentBanner
                cards
            }
            .padding()
        }
        .navigationTitle("OncoWell")
    }

    private var nextUpcoming: Appointment? {
        appointments.first { $0.status == .upcoming && $0.date > Date.now }
    }

    private var greeting: String {
        if let name = profiles.first?.name, !name.isEmpty {
            return "Welcome back, \(name)"
        }
        return "Welcome to OncoWell"
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text(greeting)
                .font(.title)
                .fontWeight(.bold)
            Text(headerSubtitle)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 32)
    }

    private var headerSubtitle: String {
        "Understand your treatment options, track your health, "
        + "and prepare for your next appointment."
    }

    private var nextAppointmentBanner: some View {
        Group {
            if let appt = nextUpcoming {
                NavigationLink {
                    AppointmentDetailView(appointment: appt)
                } label: {
                    upcomingCard(appt)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var cards: some View {
        VStack(spacing: 16) {
            healthSnapshotLink
            treatmentOptionsLink
            caregiverShareLink
        }
    }

    private var healthSnapshotLink: some View {
        NavigationLink {
            HealthDashboard()
        } label: {
            HomeCard(
                title: "Health Snapshot",
                subtitle: "Your recent vitals and activity",
                systemImage: "heart.text.square.fill",
                color: .red
            )
        }
        .buttonStyle(.plain)
    }

    private var caregiverShareLink: some View {
        NavigationLink {
            CaregiverShareView()
        } label: {
            HomeCard(
                title: "Share with Caregiver",
                subtitle: "Send a care update to family",
                systemImage: "person.2.fill",
                color: .teal
            )
        }
        .buttonStyle(.plain)
    }

    private var treatmentOptionsLink: some View {
        NavigationLink {
            LearnTab()
        } label: {
            HomeCard(
                title: "Treatment Options",
                subtitle: "Surgery vs. radiation — compare your options",
                systemImage: "book.fill",
                color: .blue
            )
        }
        .buttonStyle(.plain)
    }

    private func upcomingCard(_ appointment: Appointment) -> some View {
        HStack(spacing: 12) {
            VStack {
                Text(appointment.date, format: .dateTime.month(.abbreviated))
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .textCase(.uppercase)
                Text(appointment.date, format: .dateTime.day())
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .frame(width: 52, height: 52)
            .background(Color.orange.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 4) {
                Text("Next Appointment")
                    .font(.headline)
                Text(appointmentSubtitle(appointment))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }

    private func appointmentSubtitle(_ appointment: Appointment) -> String {
        var parts: [String] = []
        parts.append(appointment.appointmentType.rawValue)
        if !appointment.providerName.isEmpty {
            parts.append("with \(appointment.providerName)")
        }
        parts.append(appointment.date.formatted(date: .abbreviated, time: .shortened))
        return parts.joined(separator: " · ")
    }
}


struct HomeCard: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let color: Color

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
}


#Preview {
    NavigationStack {
        HomeTab()
    }
    .modelContainer(for: [Appointment.self, PatientProfile.self], inMemory: true)
}
