//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftData
import SwiftUI


struct ProfileEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var profile: PatientProfile

    var body: some View {
        NavigationStack {
            Form {
                nameSection
                diagnosisSection
                treatmentSection
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private var nameSection: some View {
        Section("Name") {
            TextField("Your name (optional)", text: $profile.name)
        }
    }

    private var diagnosisSection: some View {
        Section("Diagnosis") {
            Picker("Cancer Type", selection: $profile.cancerType) {
                Text("Not set").tag(CancerType?.none)
                ForEach(CancerType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(CancerType?.some(type))
                }
            }
            Picker("Stage", selection: $profile.cancerStage) {
                Text("Not set").tag(CancerStage?.none)
                ForEach(CancerStage.allCases, id: \.self) { stage in
                    Text(stage.rawValue).tag(CancerStage?.some(stage))
                }
            }
            DatePicker(
                "Diagnosis Date",
                selection: diagnosisDateBinding,
                in: ...Date.now,
                displayedComponents: .date
            )
        }
    }

    private var diagnosisDateBinding: Binding<Date> {
        Binding(
            get: { profile.diagnosisDate ?? Date.now },
            set: { profile.diagnosisDate = $0 }
        )
    }

    private var treatmentSection: some View {
        Section("Treatment") {
            Picker("Status", selection: $profile.treatmentStatus) {
                Text("Not set").tag(TreatmentStatus?.none)
                ForEach(TreatmentStatus.allCases, id: \.self) { status in
                    Text(status.rawValue).tag(TreatmentStatus?.some(status))
                }
            }
        }
    }
}
