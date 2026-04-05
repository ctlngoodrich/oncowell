//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct LearnSection: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let color: Color

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
}


struct LearnTab: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                sections
            }
            .padding()
        }
        .navigationTitle("Learn")
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text("Learn About Your Options")
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
        "Compare treatment options with information from trusted medical sources."
    }

    private var sections: some View {
        VStack(spacing: 16) {
            articleLink(
                article: TreatmentContentStore.surgeryOverview,
                systemImage: "scissors",
                color: .blue
            )
            articleLink(
                article: TreatmentContentStore.radiationOverview,
                systemImage: "waveform.path.ecg",
                color: .green
            )
            articleLink(
                article: TreatmentContentStore.comparisonArticle,
                systemImage: "arrow.left.arrow.right",
                color: .orange
            )
            articleLink(
                article: TreatmentContentStore.providerEvaluation,
                systemImage: "building.2.fill",
                color: .purple
            )
            glossaryLink
        }
    }

    private var glossaryLink: some View {
        NavigationLink {
            GlossaryListView()
        } label: {
            LearnSection(
                title: "Glossary",
                subtitle: "Medical terms in plain language",
                systemImage: "text.book.closed.fill",
                color: .teal
            )
        }
        .buttonStyle(.plain)
    }

    private func articleLink(
        article: TreatmentArticle,
        systemImage: String,
        color: Color
    ) -> some View {
        NavigationLink {
            ArticleDetailView(article: article)
        } label: {
            LearnSection(
                title: article.title,
                subtitle: article.summary,
                systemImage: systemImage,
                color: color
            )
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    NavigationStack {
        LearnTab()
    }
}
