//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct ContentSourceFooter: View {
    let source: ContentSource

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("Source", systemImage: "checkmark.shield.fill")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            Text("\(source.organization) — \(source.guidelineName), \(String(source.year))")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(disclaimer)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var disclaimer: String {
        "Medical guidelines change. Verify with your doctor or "
            + "visit the original source for the latest information."
    }
}


#Preview {
    ContentSourceFooter(
        source: TreatmentContentStore.nccnSource
    )
    .padding()
}
