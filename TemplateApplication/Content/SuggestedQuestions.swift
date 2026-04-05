//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

/// Suggested questions sourced from NCCN and ACS guidelines.
enum SuggestedQuestions {
    struct Suggestion: Identifiable {
        let id: String
        let text: String
        let category: QuestionCategory
    }

    static let all: [Suggestion] = [
        // Treatment
        Suggestion(id: "sq-1", text: "Which treatment do you recommend for my specific cancer, and why?", category: .treatment),
        Suggestion(id: "sq-2", text: "What are the expected cure rates for each option in my situation?", category: .treatment),
        Suggestion(id: "sq-3", text: "Is there a benefit to combining surgery and radiation?", category: .treatment),

        // Side Effects
        Suggestion(id: "sq-4", text: "What are the short-term and long-term side effects I should expect?", category: .sideEffects),
        Suggestion(id: "sq-5", text: "How will each option affect my daily life during and after treatment?", category: .sideEffects),

        // Recovery
        Suggestion(id: "sq-6", text: "How long is the typical recovery period?", category: .recovery),
        Suggestion(id: "sq-7", text: "What activity restrictions will I have during recovery?", category: .recovery),

        // Second Opinions
        Suggestion(id: "sq-8", text: "Can I get a second opinion before deciding?", category: .secondOpinion),
        Suggestion(id: "sq-9", text: "Are there clinical trials available for my situation?", category: .secondOpinion),

        // Provider Evaluation
        Suggestion(id: "sq-10", text: "How many patients with my type of cancer do you treat each year?", category: .providerEvaluation),
        Suggestion(id: "sq-11", text: "Do you have a tumor board that will review my case?", category: .providerEvaluation),
        Suggestion(id: "sq-12", text: "What support services are available (nutrition, social work, navigation)?", category: .providerEvaluation)
    ]

    static func questions(for category: QuestionCategory) -> [Suggestion] {
        all.filter { $0.category == category }
    }
}
