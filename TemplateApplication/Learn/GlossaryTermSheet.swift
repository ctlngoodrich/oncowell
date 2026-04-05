//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct GlossaryTermSheet: View {
    let term: GlossaryTerm

    @Environment(\.dismiss) private var dismiss


    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(term.term)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(term.definition)
                        .font(.body)
                        .lineSpacing(4)
                    Text("Source: \(term.source)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
    }
}


#Preview {
    GlossaryTermSheet(
        term: GlossaryContent.allTerms[0]
    )
}
