//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftData
import SwiftUI


struct CaregiverShareView: View {
    @Query(sort: \SymptomLogEntry.date, order: .reverse) private var symptoms: [SymptomLogEntry]
    @Query(sort: \TestResult.date, order: .reverse) private var testResults: [TestResult]
    @Query(sort: \Appointment.date, order: .forward) private var appointments: [Appointment]
    @Query(sort: \DoctorVisitNote.date, order: .reverse) private var visitNotes: [DoctorVisitNote]

    @State private var options = CaregiverSummaryGenerator.Options()
    @State private var generatedSummary: String?


    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                explanation
                toggleSection
                previewSection
                shareButton
            }
            .padding()
        }
        .navigationTitle("Share with Caregiver")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: options.includeSymptoms) { generatePreview() }
        .onChange(of: options.includeTestResults) { generatePreview() }
        .onChange(of: options.includeAppointments) { generatePreview() }
        .onChange(of: options.includeVisitNotes) { generatePreview() }
        .onChange(of: options.includeQuestions) { generatePreview() }
        .onAppear { generatePreview() }
    }

    private var explanation: some View {
        HStack(spacing: 8) {
            Image(systemName: "person.2.fill")
                .foregroundStyle(.teal)
                .accessibilityHidden(true)
            Text(explanationText)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.teal.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var explanationText: String {
        "Choose what to include in your care update. "
        + "Nothing is sent to any server — sharing uses your device's share sheet."
    }

    private var toggleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Include")
                .font(.headline)
            toggleRows
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }

    private var toggleRows: some View {
        Group {
            toggleRow(
                "Recent Symptoms",
                icon: "heart.text.square",
                color: .red,
                isOn: $options.includeSymptoms,
                count: symptoms.prefix(10).count
            )
            toggleRow(
                "Test Results",
                icon: "flask.fill",
                color: .blue,
                isOn: $options.includeTestResults,
                count: testResults.prefix(10).count
            )
            toggleRow(
                "Upcoming Appointments",
                icon: "calendar",
                color: .orange,
                isOn: $options.includeAppointments,
                count: appointments.filter { $0.status == .upcoming }.count
            )
            toggleRow(
                "Visit Notes",
                icon: "note.text",
                color: .green,
                isOn: $options.includeVisitNotes,
                count: visitNotes.prefix(5).count
            )
            toggleRow(
                "Pending Questions",
                icon: "questionmark.bubble",
                color: .purple,
                isOn: $options.includeQuestions,
                count: pendingQuestionCount
            )
        }
    }

    private var pendingQuestionCount: Int {
        appointments
            .filter { $0.status == .upcoming }
            .flatMap { $0.questions.filter { !$0.isAsked } }
            .count
    }

    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Preview")
                .font(.headline)
            if let summary = generatedSummary {
                Text(summary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    private var shareButton: some View {
        Group {
            if let summary = generatedSummary {
                ShareLink(
                    item: summary,
                    subject: Text("OncoWell Care Update"),
                    message: Text(shareMessage)
                ) {
                    Label("Share Care Update", systemImage: "square.and.arrow.up")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.teal)
            }
        }
    }

    private var shareMessage: String {
        "Here's a care update from OncoWell."
    }

    private func toggleRow(
        _ title: String,
        icon: String,
        color: Color,
        isOn: Binding<Bool>,
        count: Int
    ) -> some View {
        Toggle(isOn: isOn) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .frame(width: 24)
                    .accessibilityHidden(true)
                Text(title)
                    .font(.subheadline)
                Spacer()
                Text("\(count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .toggleStyle(.switch)
    }

    private func generatePreview() {
        generatedSummary = CaregiverSummaryGenerator.generate(
            symptoms: symptoms,
            testResults: testResults,
            appointments: appointments,
            visitNotes: visitNotes,
            options: options
        )
    }
}


#Preview {
    NavigationStack {
        CaregiverShareView()
    }
    .modelContainer(
        for: [
            SymptomLogEntry.self,
            TestResult.self,
            Appointment.self,
            DoctorVisitNote.self
        ],
        inMemory: true
    )
}
