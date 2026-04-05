//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftData
import SwiftUI


struct AppointmentForm: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    private let existingAppointment: Appointment?

    @State private var date = Date.now
    @State private var providerName = ""
    @State private var facilityName = ""
    @State private var appointmentType: AppointmentType = .consultation
    @State private var notes = ""


    // swiftlint:disable:next type_contents_order
    init(appointment: Appointment? = nil) {
        self.existingAppointment = appointment
        _date = State(initialValue: appointment?.date ?? .now)
        _providerName = State(initialValue: appointment?.providerName ?? "")
        _facilityName = State(initialValue: appointment?.facilityName ?? "")
        _appointmentType = State(initialValue: appointment?.appointmentType ?? .consultation)
        _notes = State(initialValue: appointment?.notes ?? "")
    }


    var body: some View {
        NavigationStack {
            Form {
                dateSection
                providerSection
                notesSection
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .fontWeight(.semibold)
                }
            }
        }
    }

    private var navigationTitle: String {
        existingAppointment == nil ? "New Appointment" : "Edit Appointment"
    }

    private var dateSection: some View {
        Section {
            DatePicker(
                "Date & Time",
                selection: $date,
                displayedComponents: [.date, .hourAndMinute]
            )
        }
    }

    private var providerSection: some View {
        Section("Provider") {
            TextField("Doctor's name", text: $providerName)
            TextField("Facility or hospital", text: $facilityName)
            Picker("Type", selection: $appointmentType) {
                ForEach(AppointmentType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
        }
    }

    private var notesSection: some View {
        Section("Notes (Optional)") {
            TextField("Notes", text: $notes, axis: .vertical)
                .lineLimit(3...6)
        }
    }

    private func save() {
        if let existingAppointment {
            existingAppointment.date = date
            existingAppointment.providerName = providerName
            existingAppointment.facilityName = facilityName
            existingAppointment.appointmentType = appointmentType
            existingAppointment.notes = notes
            scheduleReminder(for: existingAppointment)
        } else {
            let appointment = Appointment(
                date: date,
                providerName: providerName,
                facilityName: facilityName,
                appointmentType: appointmentType,
                notes: notes
            )
            modelContext.insert(appointment)
            scheduleReminder(for: appointment)
        }
        dismiss()
    }

    private func scheduleReminder(for appointment: Appointment) {
        guard AppStorage(wrappedValue: false, "appointmentReminders").wrappedValue else {
            return
        }
        let reminderInfo = NotificationService.AppointmentInfo(
            id: appointment.persistentModelID.hashValue,
            date: appointment.date,
            typeName: appointment.appointmentType.rawValue,
            providerName: appointment.providerName
        )
        Task {
            await NotificationService.scheduleAppointmentReminder(info: reminderInfo)
        }
    }
}


#Preview {
    AppointmentForm()
        .modelContainer(for: Appointment.self, inMemory: true)
}
