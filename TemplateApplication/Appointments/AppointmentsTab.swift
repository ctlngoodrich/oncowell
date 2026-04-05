//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftData
import SwiftUI


struct AppointmentCard: View {
    let appointment: Appointment

    var body: some View {
        HStack(spacing: 12) {
            statusIcon
            details
            Spacer()
            dateLabel
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }

    private var statusIcon: some View {
        Image(systemName: appointment.status.systemImage)
            .font(.title2)
            .foregroundStyle(statusColor)
            .accessibilityLabel(appointment.status.rawValue)
    }

    private var statusColor: Color {
        switch appointment.status {
        case .upcoming: .blue
        case .completed: .green
        case .cancelled: .secondary
        }
    }

    private var details: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(appointment.appointmentType.rawValue)
                .font(.headline)
            if !appointment.providerName.isEmpty {
                Text(appointment.providerName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            if !appointment.facilityName.isEmpty {
                Text(appointment.facilityName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var dateLabel: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text(appointment.date, style: .date)
                .font(.caption)
            Text(appointment.date, style: .time)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}


struct AppointmentsTab: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Appointment.date, order: .forward) private var appointments: [Appointment]

    @State private var showingForm = false


    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                addButton
                if appointments.isEmpty {
                    emptyState
                } else {
                    appointmentsList
                }
            }
            .padding()
        }
        .navigationTitle("Appointments")
        .sheet(isPresented: $showingForm) {
            AppointmentForm()
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text("Your Appointments")
                .font(.title2)
                .fontWeight(.bold)
            Text(headerSubtitle)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 16)
    }

    private var headerSubtitle: String {
        "Manage appointments, build question lists, and record visits."
    }

    private var addButton: some View {
        Button { showingForm = true } label: {
            Label("Add Appointment", systemImage: "plus.circle.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
    }

    private var emptyState: some View {
        ContentUnavailableView(
            "No appointments",
            systemImage: "calendar.badge.plus",
            description: Text(emptyStateMessage)
        )
    }

    private var emptyStateMessage: String {
        "Add your upcoming doctor appointments to prepare questions and track your visits."
    }

    private var upcomingAppointments: [Appointment] {
        appointments.filter { $0.status == .upcoming }
    }

    private var pastAppointments: [Appointment] {
        appointments.filter { $0.status != .upcoming }
    }

    private var appointmentsList: some View {
        VStack(spacing: 20) {
            if !upcomingAppointments.isEmpty {
                appointmentGroup(title: "Upcoming", appointments: upcomingAppointments)
            }
            if !pastAppointments.isEmpty {
                appointmentGroup(title: "Past", appointments: pastAppointments)
            }
        }
    }

    private func appointmentGroup(title: String, appointments: [Appointment]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            ForEach(appointments) { appointment in
                NavigationLink {
                    AppointmentDetailView(appointment: appointment)
                } label: {
                    AppointmentCard(appointment: appointment)
                }
                .buttonStyle(.plain)
                .contextMenu {
                    Button(role: .destructive) {
                        modelContext.delete(appointment)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }
}


#Preview {
    NavigationStack {
        AppointmentsTab()
    }
    .modelContainer(for: Appointment.self, inMemory: true)
}
