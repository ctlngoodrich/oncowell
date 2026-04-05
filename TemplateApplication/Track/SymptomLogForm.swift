//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftData
import SwiftUI


struct SymptomLogForm: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var date = Date.now
    @State private var symptomType: SymptomType = .pain
    @State private var severity: SymptomSeverity = .moderate
    @State private var bodyLocation = ""
    @State private var notes = ""


    var body: some View {
        NavigationStack {
            Form {
                dateSection
                symptomSection
                severitySection
                detailsSection
            }
            .navigationTitle("Log a Symptom")
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

    private var dateSection: some View {
        Section {
            DatePicker(
                "Date & Time",
                selection: $date,
                in: ...Date.now,
                displayedComponents: [.date, .hourAndMinute]
            )
        }
    }

    private var symptomSection: some View {
        Section("Symptom") {
            Picker("Type", selection: $symptomType) {
                ForEach(SymptomType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
        }
    }

    private var severitySection: some View {
        Section("Severity") {
            Picker("Severity", selection: $severity) {
                ForEach(SymptomSeverity.allCases, id: \.self) { level in
                    Text(level.label).tag(level)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private var detailsSection: some View {
        Section("Details (Optional)") {
            if symptomType == .pain {
                TextField("Body location", text: $bodyLocation)
            }
            TextField("Notes", text: $notes, axis: .vertical)
                .lineLimit(3...6)
        }
    }

    private func save() {
        let entry = SymptomLogEntry(
            date: date,
            symptomType: symptomType,
            severity: severity,
            bodyLocation: bodyLocation,
            notes: notes
        )
        modelContext.insert(entry)
        dismiss()
    }
}


#Preview {
    SymptomLogForm()
        .modelContainer(for: SymptomLogEntry.self, inMemory: true)
}
