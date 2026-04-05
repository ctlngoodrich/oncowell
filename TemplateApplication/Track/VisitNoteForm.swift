//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftData
import SwiftUI


struct VisitNoteForm: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var date: Date
    @State private var providerName: String
    @State private var facilityName: String
    @State private var visitType: VisitType
    @State private var summary: String
    @State private var decisionsAndNextSteps: String

    private let existingNote: DoctorVisitNote?

    // swiftlint:disable:next type_contents_order
    init(note: DoctorVisitNote? = nil) {
        self.existingNote = note
        _date = State(initialValue: note?.date ?? .now)
        _providerName = State(initialValue: note?.providerName ?? "")
        _facilityName = State(initialValue: note?.facilityName ?? "")
        _visitType = State(initialValue: note?.visitType ?? .consultation)
        _summary = State(initialValue: note?.summary ?? "")
        _decisionsAndNextSteps = State(initialValue: note?.decisionsAndNextSteps ?? "")
    }

    // swiftlint:disable:next type_contents_order
    init(forAppointment appointment: Appointment) {
        self.existingNote = nil
        _date = State(initialValue: appointment.date)
        _providerName = State(initialValue: appointment.providerName)
        _facilityName = State(initialValue: appointment.facilityName)
        _visitType = State(initialValue: .consultation)
        _summary = State(initialValue: "")
        _decisionsAndNextSteps = State(initialValue: "")
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
        existingNote == nil ? "Add Visit Note" : "Edit Visit Note"
    }

    private var dateSection: some View {
        Section {
            DatePicker(
                "Visit Date",
                selection: $date,
                in: ...Date.now,
                displayedComponents: [.date]
            )
        }
    }

    private var providerSection: some View {
        Section("Provider") {
            TextField("Doctor's name", text: $providerName)
            TextField("Facility or hospital", text: $facilityName)
            Picker("Visit type", selection: $visitType) {
                ForEach(VisitType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
        }
    }

    private var notesSection: some View {
        Section("Notes") {
            Text("Summary")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            TextField("What was discussed?", text: $summary, axis: .vertical)
                .lineLimit(4...10)
            Text("Decisions & Next Steps")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            TextField(
                "Key decisions, follow-ups, or action items",
                text: $decisionsAndNextSteps,
                axis: .vertical
            )
            .lineLimit(3...8)
        }
    }

    private func save() {
        if let existingNote {
            existingNote.date = date
            existingNote.providerName = providerName
            existingNote.facilityName = facilityName
            existingNote.visitType = visitType
            existingNote.summary = summary
            existingNote.decisionsAndNextSteps = decisionsAndNextSteps
        } else {
            let note = DoctorVisitNote(
                date: date,
                providerName: providerName,
                facilityName: facilityName,
                visitType: visitType,
                summary: summary,
                decisionsAndNextSteps: decisionsAndNextSteps
            )
            modelContext.insert(note)
        }
        dismiss()
    }
}


#Preview {
    VisitNoteForm()
        .modelContainer(for: DoctorVisitNote.self, inMemory: true)
}
