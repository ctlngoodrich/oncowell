//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftData
import SwiftUI


// swiftlint:disable:next file_types_order
struct DataManagementView: View {
    @Environment(\.modelContext) private var modelContext

    @Query private var symptoms: [SymptomLogEntry]
    @Query private var testResults: [TestResult]
    @Query private var visitNotes: [DoctorVisitNote]
    @Query private var appointments: [Appointment]
    @Query private var recordings: [AppointmentRecording]

    @State private var showingDeleteAll = false
    @State private var deleteTarget: DeleteTarget?


    var body: some View {
        List {
            dataOverviewSection
            deleteIndividualSection
            deleteAllSection
        }
        .navigationTitle("Manage Data")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete All Data?", isPresented: $showingDeleteAll) {
            Button("Delete Everything", role: .destructive) { deleteAllData() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text(deleteAllMessage)
        }
        .alert(item: $deleteTarget) { target in
            Alert(
                title: Text("Delete \(target.label)?"),
                message: Text("This will permanently delete \(target.count) \(target.itemName). This cannot be undone."),
                primaryButton: .destructive(Text("Delete")) { performDelete(target) },
                secondaryButton: .cancel()
            )
        }
    }

    private var deleteAllMessage: String {
        "This will permanently delete all your symptoms, test results, "
        + "visit notes, appointments, recordings, and profile data. "
        + "This cannot be undone."
    }

    private var dataOverviewSection: some View {
        Section("Your Data") {
            dataRow("Symptoms", count: symptoms.count, icon: "heart.text.square", color: .red)
            dataRow("Test Results", count: testResults.count, icon: "flask.fill", color: .blue)
            dataRow("Visit Notes", count: visitNotes.count, icon: "note.text", color: .green)
            dataRow("Appointments", count: appointments.count, icon: "calendar", color: .orange)
            dataRow("Recordings", count: recordings.count, icon: "waveform", color: .purple)
        }
    }

    private var deleteIndividualSection: some View {
        Section("Delete by Category") {
            deleteButton("Symptoms", target: .symptoms(symptoms.count))
            deleteButton("Test Results", target: .testResults(testResults.count))
            deleteButton("Visit Notes", target: .visitNotes(visitNotes.count))
            deleteButton("Appointments", target: .appointments(appointments.count))
            deleteButton("Recordings", target: .recordings(recordings.count))
        }
    }

    private var deleteAllSection: some View {
        Section {
            Button(role: .destructive) {
                showingDeleteAll = true
            } label: {
                HStack {
                    Spacer()
                    Label("Delete All Data", systemImage: "trash.fill")
                        .fontWeight(.semibold)
                    Spacer()
                }
            }
        } footer: {
            Text("This removes all data and resets the app.")
        }
    }

    private func dataRow(_ title: String, count: Int, icon: String, color: Color) -> some View {
        HStack {
            Label(title, systemImage: icon)
                .foregroundStyle(color)
            Spacer()
            Text("\(count)")
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
    }

    private func deleteButton(_ title: String, target: DeleteTarget) -> some View {
        Button(role: .destructive) {
            if !target.isEmpty {
                deleteTarget = target
            }
        } label: {
            Text("Delete All \(title)")
        }
        .disabled(target.isEmpty)
    }

    private func performDelete(_ target: DeleteTarget) {
        switch target {
        case .symptoms:
            symptoms.forEach { modelContext.delete($0) }
        case .testResults:
            testResults.forEach { modelContext.delete($0) }
        case .visitNotes:
            visitNotes.forEach { modelContext.delete($0) }
        case .appointments:
            appointments.forEach { modelContext.delete($0) }
        case .recordings:
            deleteRecordings()
        }
    }

    private func deleteRecordings() {
        for recording in recordings {
            if let url = recording.audioFileURL {
                try? FileManager.default.removeItem(at: url)
            }
            modelContext.delete(recording)
        }
    }

    private func deleteAllData() {
        symptoms.forEach { modelContext.delete($0) }
        testResults.forEach { modelContext.delete($0) }
        visitNotes.forEach { modelContext.delete($0) }
        deleteRecordings()
        appointments.forEach { modelContext.delete($0) }

        UserDefaults.standard.set(false, forKey: StorageKeys.onboardingFlowComplete)
    }
}


enum DeleteTarget: Identifiable {
    case symptoms(Int)
    case testResults(Int)
    case visitNotes(Int)
    case appointments(Int)
    case recordings(Int)

    var id: String { label }

    var label: String {
        switch self {
        case .symptoms: "Symptoms"
        case .testResults: "Test Results"
        case .visitNotes: "Visit Notes"
        case .appointments: "Appointments"
        case .recordings: "Recordings"
        }
    }

    var count: Int {
        switch self {
        case .symptoms(let count), .testResults(let count), .visitNotes(let count),
             .appointments(let count), .recordings(let count):
            count
        }
    }

    var isEmpty: Bool {
        switch self {
        case .symptoms(0), .testResults(0), .visitNotes(0),
             .appointments(0), .recordings(0):
            true
        default:
            false
        }
    }

    var itemName: String {
        count == 1 ? label.lowercased().dropLast().description : label.lowercased()
    }
}
