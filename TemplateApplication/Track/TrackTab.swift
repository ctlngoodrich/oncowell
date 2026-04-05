//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftData
import SwiftUI


struct TrackAction: View {
    let title: String
    let systemImage: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(color)
                .accessibilityHidden(true)
            Text(title)
                .font(.headline)
            Spacer()
            Image(systemName: "plus.circle.fill")
                .font(.title3)
                .foregroundStyle(color)
                .accessibilityHidden(true)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
}


struct TrackTab: View {
    @Environment(\.modelContext) private var modelContext

    // swiftlint:disable attributes
    @Query(sort: \SymptomLogEntry.date, order: .reverse)
    private var symptoms: [SymptomLogEntry]

    @Query(sort: \TestResult.date, order: .reverse)
    private var testResults: [TestResult]

    @Query(sort: \DoctorVisitNote.date, order: .reverse)
    private var visitNotes: [DoctorVisitNote]
    // swiftlint:enable attributes

    @State private var showingSymptomForm = false
    @State private var showingTestResultForm = false
    @State private var showingVisitNoteForm = false


    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                actions
                timeline
            }
            .padding()
        }
        .navigationTitle("Track")
        .sheet(isPresented: $showingSymptomForm) {
            SymptomLogForm()
        }
        .sheet(isPresented: $showingTestResultForm) {
            TestResultForm()
        }
        .sheet(isPresented: $showingVisitNoteForm) {
            VisitNoteForm()
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text("Track Your Health")
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
        "Log symptoms, record test results, and keep notes from doctor visits."
    }

    private var actions: some View {
        VStack(spacing: 12) {
            Button { showingSymptomForm = true } label: {
                TrackAction(
                    title: "Log a Symptom",
                    systemImage: "heart.text.square",
                    color: .red
                )
            }
            .buttonStyle(.plain)
            Button { showingTestResultForm = true } label: {
                TrackAction(
                    title: "Add Test Result",
                    systemImage: "flask.fill",
                    color: .blue
                )
            }
            .buttonStyle(.plain)
            Button { showingVisitNoteForm = true } label: {
                TrackAction(
                    title: "Add Visit Note",
                    systemImage: "note.text",
                    color: .green
                )
            }
            .buttonStyle(.plain)
        }
    }

    private var timelineEntries: [TimelineEntry] {
        let symptomEntries = symptoms.map { TimelineEntry.symptom($0) }
        let testEntries = testResults.map { TimelineEntry.testResult($0) }
        let visitEntries = visitNotes.map { TimelineEntry.visitNote($0) }
        return (symptomEntries + testEntries + visitEntries)
            .sorted { $0.date > $1.date }
    }

    private var timeline: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Timeline")
                .font(.headline)
            if timelineEntries.isEmpty {
                emptyTimeline
            } else {
                timelineList
            }
        }
    }

    private var emptyTimeline: some View {
        ContentUnavailableView(
            "No entries yet",
            systemImage: "clock",
            description: Text(emptyTimelineMessage)
        )
    }

    private var emptyTimelineMessage: String {
        "Your symptoms, test results, and visit notes will appear here."
    }

    private var timelineList: some View {
        LazyVStack(spacing: 8) {
            ForEach(timelineEntries) { entry in
                timelineRow(for: entry)
                    .contextMenu {
                        Button(role: .destructive) {
                            deleteEntry(entry)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
    }

    @ViewBuilder
    private func timelineRow(for entry: TimelineEntry) -> some View {
        switch entry {
        case .symptom(let symptom):
            SymptomRow(entry: symptom)
        case .testResult(let result):
            TestResultRow(result: result)
        case .visitNote(let note):
            NavigationLink {
                VisitNoteDetailView(note: note)
            } label: {
                VisitNoteRow(note: note)
            }
            .buttonStyle(.plain)
        }
    }

    private func deleteEntry(_ entry: TimelineEntry) {
        switch entry {
        case .symptom(let symptom):
            modelContext.delete(symptom)
        case .testResult(let result):
            modelContext.delete(result)
        case .visitNote(let note):
            modelContext.delete(note)
        }
    }
}


#Preview {
    NavigationStack {
        TrackTab()
    }
    .modelContainer(
        for: [SymptomLogEntry.self, TestResult.self, DoctorVisitNote.self],
        inMemory: true
    )
}
