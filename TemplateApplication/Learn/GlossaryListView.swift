//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct GlossaryListView: View {
    @State private var searchText = ""
    @State private var selectedTerm: GlossaryTerm?


    private var filteredTerms: [GlossaryTerm] {
        if searchText.isEmpty {
            return GlossaryContent.allTerms
        }
        return GlossaryContent.terms(matching: searchText)
    }

    var body: some View {
        List(filteredTerms) { term in
            Button {
                selectedTerm = term
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(term.term)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(term.definition)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .padding(.vertical, 4)
            }
        }
        .overlay {
            if filteredTerms.isEmpty && !searchText.isEmpty {
                ContentUnavailableView.search(text: searchText)
            }
        }
        .searchable(text: $searchText, prompt: "Search terms")
        .navigationTitle("Glossary")
        .sheet(item: $selectedTerm) { term in
            GlossaryTermSheet(term: term)
        }
    }
}


#Preview {
    NavigationStack {
        GlossaryListView()
    }
}
