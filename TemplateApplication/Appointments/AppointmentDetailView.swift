//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftData
import SwiftUI


struct AppointmentDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var appointment: Appointment
    @State private var showingEditForm = false


    var body: some View {
        List {
            detailsSection
            statusSection
            questionsLink
            recordingLink
            if !appointment.notes.isEmpty {
                notesSection
            }
            actionsSection
        }
        .navigationTitle(appointment.appointmentType.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") { showingEditForm = true }
            }
        }
        .sheet(isPresented: $showingEditForm) {
            AppointmentForm(appointment: appointment)
        }
    }

    private var detailsSection: some View {
        Section {
            LabeledContent("Date") {
                Text(appointment.date, style: .date)
            }
            LabeledContent("Time") {
                Text(appointment.date, style: .time)
            }
            if !appointment.providerName.isEmpty {
                LabeledContent("Provider", value: appointment.providerName)
            }
            if !appointment.facilityName.isEmpty {
                LabeledContent("Facility", value: appointment.facilityName)
            }
        }
    }

    private var statusSection: some View {
        Section("Status") {
            Picker("Status", selection: $appointment.status) {
                ForEach(AppointmentStatus.allCases, id: \.self) { status in
                    Label(status.rawValue, systemImage: status.systemImage)
                        .tag(status)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private var questionsLink: some View {
        Section {
            NavigationLink {
                QuestionListView(appointment: appointment)
            } label: {
                HStack {
                    Label("Questions", systemImage: "questionmark.bubble")
                    Spacer()
                    Text("\(appointment.questions.count)")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var notesSection: some View {
        Section("Notes") {
            Text(appointment.notes)
                .font(.body)
        }
    }

    private var recordingLink: some View {
        Section {
            NavigationLink {
                RecordingView(appointment: appointment)
            } label: {
                HStack {
                    Label("Recording", systemImage: "mic.fill")
                    Spacer()
                    if appointment.recording != nil {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .accessibilityLabel("Has recording")
                    }
                }
            }
        }
    }

    private var actionsSection: some View {
        Section {
            NavigationLink {
                VisitNoteForm(forAppointment: appointment)
            } label: {
                Label("Create Visit Note", systemImage: "note.text.badge.plus")
            }
        }
    }
}
