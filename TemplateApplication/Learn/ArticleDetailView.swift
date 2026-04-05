//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct ArticleDetailView: View {
    let article: TreatmentArticle

    @State private var selectedTerm: GlossaryTerm?


    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                articleHeader
                ForEach(article.sections) { section in
                    sectionView(section)
                }
                relatedTerms
                sourceFooter
            }
            .padding()
        }
        .navigationTitle(article.title)
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $selectedTerm) { term in
            GlossaryTermSheet(term: term)
        }
    }

    private var articleHeader: some View {
        Text(article.summary)
            .font(.body)
            .foregroundStyle(.secondary)
    }

    private var relatedTerms: some View {
        Group {
            if !article.relatedTermIDs.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Related Terms")
                        .font(.headline)
                    FlowLayout(spacing: 8) {
                        ForEach(glossaryTerms, id: \.id) { term in
                            Button {
                                selectedTerm = term
                            } label: {
                                Text(term.term)
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.accentColor.opacity(0.12))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
        }
    }

    private var sourceFooter: some View {
        ContentSourceFooter(source: article.source)
    }

    private var glossaryTerms: [GlossaryTerm] {
        article.relatedTermIDs.compactMap { GlossaryContent.term(byID: $0) }
    }

    private func sectionView(_ section: ContentSection) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(section.heading)
                .font(.title3)
                .fontWeight(.semibold)
            Text(section.body)
                .font(.body)
                .lineSpacing(4)
        }
    }
}


#Preview {
    NavigationStack {
        ArticleDetailView(article: TreatmentContentStore.surgeryOverview)
    }
}
