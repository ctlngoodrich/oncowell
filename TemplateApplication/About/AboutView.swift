//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct DisclaimerCard: View {
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: "info.circle.fill")
                .font(.headline)
                .foregroundStyle(.primary)
            Text(text)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}


struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                aboutHeader
                disclaimers
            }
            .padding()
        }
        .navigationTitle("About OncoWell")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var aboutHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("A personal care navigation tool.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    private var disclaimers: some View {
        VStack(alignment: .leading, spacing: 16) {
            DisclaimerCard(
                title: "Not Medical Advice",
                text: "OncoWell is an educational and organizational tool. "
                    + "It does not provide medical advice, diagnosis, or "
                    + "treatment recommendations. Always consult your "
                    + "healthcare provider."
            )
            DisclaimerCard(
                title: "Content Sources",
                text: "Treatment information is sourced from NCCN, AMA, "
                    + "and ACS guidelines. Medical guidelines change — "
                    + "verify with your doctor or visit the original "
                    + "source for updates."
            )
            DisclaimerCard(
                title: "Your Data",
                text: "All your data stays on this device. OncoWell does "
                    + "not send your health information to any server or "
                    + "third party."
            )
            DisclaimerCard(
                title: "Recording",
                text: "Please inform your healthcare provider before "
                    + "recording any appointment. Recording laws vary "
                    + "by state."
            )
            DisclaimerCard(
                title: "Transcription",
                text: "Transcripts are generated automatically and may "
                    + "contain errors. Confirm important details with "
                    + "your healthcare provider."
            )
        }
    }
}


#Preview {
    NavigationStack {
        AboutView()
    }
}
