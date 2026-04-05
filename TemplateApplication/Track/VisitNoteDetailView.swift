//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct VisitNoteDetailView: View {
    let note: DoctorVisitNote
    @State private var showingEditForm = false


    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                visitHeader
                if !note.summary.isEmpty {
                    summarySection
                }
                if !note.decisionsAndNextSteps.isEmpty {
                    nextStepsSection
                }
            }
            .padding()
        }
        .navigationTitle("Visit Note")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") { showingEditForm = true }
            }
        }
        .sheet(isPresented: $showingEditForm) {
            VisitNoteForm(note: note)
        }
    }

    private var visitHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label(note.visitType.rawValue, systemImage: "stethoscope")
                    .font(.subheadline)
                    .foregroundStyle(.green)
                Spacer()
                Text(note.date, style: .date)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            if !note.providerName.isEmpty {
                Text(note.providerName)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            if !note.facilityName.isEmpty {
                Text(note.facilityName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }

    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Summary")
                .font(.headline)
            Text(note.summary)
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }

    private var nextStepsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Decisions & Next Steps")
                .font(.headline)
            Text(note.decisionsAndNextSteps)
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
}


#Preview {
    NavigationStack {
        VisitNoteDetailView(
            note: DoctorVisitNote(
                providerName: "Dr. Smith",
                facilityName: "Stanford Cancer Center",
                visitType: .consultation,
                summary: "Discussed treatment options. Surgery and radiation both viable.",
                decisionsAndNextSteps: "Schedule follow-up MRI. Get second opinion at UCSF."
            )
        )
    }
}
