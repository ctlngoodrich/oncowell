//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftData
import SwiftUI


struct TestResultForm: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var date = Date.now
    @State private var testType: TestType = .psa
    @State private var testName = ""
    @State private var value = ""
    @State private var unit = ""
    @State private var referenceRange = ""
    @State private var notes = ""


    var body: some View {
        NavigationStack {
            Form {
                dateSection
                testSection
                valueSection
                notesSection
            }
            .navigationTitle("Add Test Result")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .fontWeight(.semibold)
                        .disabled(value.isEmpty)
                }
            }
            .onChange(of: testType) {
                unit = testType.suggestedUnit
            }
        }
    }

    private var dateSection: some View {
        Section {
            DatePicker(
                "Test Date",
                selection: $date,
                in: ...Date.now,
                displayedComponents: .date
            )
        }
    }

    private var testSection: some View {
        Section("Test") {
            Picker("Type", selection: $testType) {
                ForEach(TestType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            if testType == .other {
                TextField("Test name", text: $testName)
            }
        }
    }

    private var valueSection: some View {
        Section("Result") {
            TextField("Value", text: $value)
                .keyboardType(.decimalPad)
            TextField("Unit", text: $unit)
            TextField("Reference range (optional)", text: $referenceRange)
        }
    }

    private var notesSection: some View {
        Section("Notes (Optional)") {
            TextField("Notes", text: $notes, axis: .vertical)
                .lineLimit(3...6)
        }
    }

    private func save() {
        let displayName = testType == .other ? testName : testType.rawValue
        let result = TestResult(
            date: date,
            testType: testType,
            testName: displayName,
            value: value,
            unit: unit,
            referenceRange: referenceRange,
            notes: notes
        )
        modelContext.insert(result)
        dismiss()
    }
}


#Preview {
    TestResultForm()
        .modelContainer(for: TestResult.self, inMemory: true)
}
