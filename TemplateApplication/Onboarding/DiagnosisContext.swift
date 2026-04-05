//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziViews
import SwiftData
import SwiftUI


struct DiagnosisContext: View {
    @Environment(ManagedNavigationStack.Path.self) private var path
    @Environment(\.modelContext) private var modelContext

    @State private var selectedCancerType: CancerType?
    @State private var selectedStage: CancerStage?
    @State private var selectedStatus: TreatmentStatus?


    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                cancerTypeSection
                stageSection
                statusSection
            }
            .padding()
        }
        .safeAreaInset(edge: .bottom) {
            saveButton
        }
        .navigationTitle("About You")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Skip") {
                    saveProfile()
                    path.nextStep()
                }
            }
        }
    }

    private var header: some View {
        Text("Tell us a bit about your situation so we can show you the most relevant information. You can change this later.")
            .font(.body)
            .foregroundStyle(.secondary)
    }

    private var cancerTypeSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Cancer Type")
                .font(.headline)
            FlowLayout(spacing: 8) {
                ForEach(CancerType.allCases, id: \.self) { type in
                    ChipButton(
                        title: type.rawValue,
                        isSelected: selectedCancerType == type
                    ) {
                        selectedCancerType = selectedCancerType == type ? nil : type
                    }
                }
            }
        }
    }

    private var stageSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Stage")
                .font(.headline)
            FlowLayout(spacing: 8) {
                ForEach(CancerStage.allCases, id: \.self) { stage in
                    ChipButton(
                        title: stage.rawValue,
                        isSelected: selectedStage == stage
                    ) {
                        selectedStage = selectedStage == stage ? nil : stage
                    }
                }
            }
        }
    }

    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Where Are You Now?")
                .font(.headline)
            FlowLayout(spacing: 8) {
                ForEach(TreatmentStatus.allCases, id: \.self) { status in
                    ChipButton(
                        title: status.rawValue,
                        isSelected: selectedStatus == status
                    ) {
                        selectedStatus = selectedStatus == status ? nil : status
                    }
                }
            }
        }
    }

    private var saveButton: some View {
        Button {
            saveProfile()
            path.nextStep()
        } label: {
            Text("Continue")
                .frame(maxWidth: .infinity)
                .font(.headline)
        }
        .buttonStyle(.borderedProminent)
        .padding()
        .background(.ultraThinMaterial)
    }

    private func saveProfile() {
        let profile = PatientProfile(
            cancerType: selectedCancerType,
            cancerStage: selectedStage,
            treatmentStatus: selectedStatus
        )
        modelContext.insert(profile)
    }
}


#Preview {
    ManagedNavigationStack {
        DiagnosisContext()
    }
    .modelContainer(for: PatientProfile.self, inMemory: true)
}
