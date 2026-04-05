//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftData
import SwiftUI


struct QuestionListView: View {
    @Environment(\.modelContext) private var modelContext
    let appointment: Appointment

    @State private var newQuestionText = ""
    @State private var selectedCategory: QuestionCategory = .general
    @State private var showingSuggestions = false


    var body: some View {
        List {
            addQuestionSection
            if sortedQuestions.isEmpty {
                Section {
                    ContentUnavailableView(
                        "No Questions Yet",
                        systemImage: "questionmark.bubble",
                        description: Text(emptyQuestionsMessage)
                    )
                    .listRowBackground(Color.clear)
                }
            } else {
                questionsSection
            }
        }
        .navigationTitle("Questions")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button { showingSuggestions = true } label: {
                        Label("Suggested Questions", systemImage: "lightbulb")
                    }
                    ShareLink(item: shareText) {
                        Label("Share Questions", systemImage: "square.and.arrow.up")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .accessibilityLabel("More options")
                }
            }
        }
        .sheet(isPresented: $showingSuggestions) {
            SuggestedQuestionsSheet(appointment: appointment)
        }
    }

    private var emptyQuestionsMessage: String {
        "Type a question above or tap the menu for suggested questions to ask your doctor."
    }

    private var sortedQuestions: [QuestionItem] {
        appointment.questions.sorted { $0.sortOrder < $1.sortOrder }
    }

    private var addQuestionSection: some View {
        Section {
            HStack {
                TextField("Add a question", text: $newQuestionText)
                Button(action: addQuestion) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .accessibilityLabel("Add question")
                }
                .disabled(newQuestionText.isEmpty)
            }
            Picker("Category", selection: $selectedCategory) {
                ForEach(QuestionCategory.allCases, id: \.self) { cat in
                    Text(cat.rawValue).tag(cat)
                }
            }
            .pickerStyle(.menu)
        }
    }

    private var questionsSection: some View {
        Section("Your Questions") {
            ForEach(sortedQuestions) { question in
                QuestionRow(question: question)
            }
            .onDelete(perform: deleteQuestions)
        }
    }

    private var shareText: String {
        let header = "Questions for my appointment"
            + (appointment.providerName.isEmpty ? "" : " with \(appointment.providerName)")
            + "\n\n"
        let lines = sortedQuestions.map { question in
            let check = question.isAsked ? "[x]" : "[ ]"
            var line = "\(check) \(question.text)"
            if !question.answerNotes.isEmpty {
                line += "\n    Answer: \(question.answerNotes)"
            }
            return line
        }
        return header + lines.joined(separator: "\n")
    }

    private func addQuestion() {
        let item = QuestionItem(
            text: newQuestionText,
            category: selectedCategory,
            sortOrder: appointment.questions.count,
            appointment: appointment
        )
        modelContext.insert(item)
        newQuestionText = ""
    }

    private func deleteQuestions(at offsets: IndexSet) {
        for index in offsets {
            let question = sortedQuestions[index]
            modelContext.delete(question)
        }
    }
}
