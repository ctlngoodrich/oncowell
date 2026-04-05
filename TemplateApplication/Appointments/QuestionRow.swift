//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftData
import SwiftUI


struct QuestionRow: View {
    @Bindable var question: QuestionItem
    @State private var showingAnswer = false


    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            questionHeader
            categoryLabel
            if showingAnswer || !question.answerNotes.isEmpty {
                answerField
            }
        }
        .padding(.vertical, 4)
    }

    private var questionHeader: some View {
        HStack(alignment: .top, spacing: 10) {
            Button {
                question.isAsked.toggle()
                if question.isAsked { showingAnswer = true }
            } label: {
                Image(systemName: checkmarkImage)
                    .foregroundStyle(question.isAsked ? .green : .secondary)
                    .font(.title3)
                    .accessibilityLabel(question.isAsked ? "Asked" : "Not asked")
            }
            .buttonStyle(.plain)
            Text(question.text)
                .font(.body)
                .strikethrough(question.isAsked)
                .foregroundStyle(question.isAsked ? .secondary : .primary)
        }
    }

    private var checkmarkImage: String {
        question.isAsked ? "checkmark.circle.fill" : "circle"
    }

    private var categoryLabel: some View {
        Text(question.category.rawValue)
            .font(.caption2)
            .foregroundStyle(.secondary)
            .padding(.leading, 34)
    }

    private var answerField: some View {
        TextField("Answer notes", text: $question.answerNotes, axis: .vertical)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .lineLimit(2...4)
            .padding(.leading, 34)
    }
}
