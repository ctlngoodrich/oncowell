//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftData
import SwiftUI


struct SuggestedQuestionsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let appointment: Appointment

    @State private var selected: Set<String> = []


    var body: some View {
        NavigationStack {
            List {
                ForEach(QuestionCategory.allCases, id: \.self) { category in
                    categorySection(category)
                }
            }
            .navigationTitle("Suggested Questions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add \(addButtonLabel)", action: addSelected)
                        .fontWeight(.semibold)
                        .disabled(selected.isEmpty)
                }
            }
        }
    }

    private var addButtonLabel: String {
        selected.isEmpty ? "Selected" : "(\(selected.count))"
    }

    private func categorySection(_ category: QuestionCategory) -> some View {
        let questions = SuggestedQuestions.questions(for: category)
        return Group {
            if !questions.isEmpty {
                Section(category.rawValue) {
                    ForEach(questions) { suggestion in
                        suggestionRow(suggestion)
                    }
                }
            }
        }
    }

    private func suggestionRow(_ suggestion: SuggestedQuestions.Suggestion) -> some View {
        let isSelected = selected.contains(suggestion.id)
        let alreadyAdded = appointment.questions.contains {
            $0.text == suggestion.text
        }
        return Button {
            if isSelected {
                selected.remove(suggestion.id)
            } else {
                selected.insert(suggestion.id)
            }
        } label: {
            HStack {
                Text(suggestion.text)
                    .font(.body)
                    .foregroundStyle(alreadyAdded ? .secondary : .primary)
                Spacer()
                if alreadyAdded {
                    Text("Added")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.blue)
                        .accessibilityLabel("Selected")
                } else {
                    Image(systemName: "circle")
                        .foregroundStyle(.secondary)
                        .accessibilityLabel("Not selected")
                }
            }
        }
        .disabled(alreadyAdded)
    }

    private func addSelected() {
        let currentCount = appointment.questions.count
        let suggestions = SuggestedQuestions.all.filter {
            selected.contains($0.id)
        }
        for (index, suggestion) in suggestions.enumerated() {
            let item = QuestionItem(
                text: suggestion.text,
                category: suggestion.category,
                sortOrder: currentCount + index,
                appointment: appointment
            )
            modelContext.insert(item)
        }
        dismiss()
    }
}
