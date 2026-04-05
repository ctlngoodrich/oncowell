//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftData


enum QuestionCategory: String, Codable, CaseIterable {
    case treatment = "Treatment"
    case sideEffects = "Side Effects"
    case recovery = "Recovery"
    case secondOpinion = "Second Opinions"
    case providerEvaluation = "Provider Evaluation"
    case general = "General"
}


@Model
final class QuestionItem {
    var text: String
    var category: QuestionCategory
    var isAsked: Bool
    var answerNotes: String
    var sortOrder: Int
    @Relationship(inverse: \Appointment.questions) var appointment: Appointment?

    init(
        text: String = "",
        category: QuestionCategory = .general,
        isAsked: Bool = false,
        answerNotes: String = "",
        sortOrder: Int = 0,
        appointment: Appointment? = nil
    ) {
        self.text = text
        self.category = category
        self.isAsked = isAsked
        self.answerNotes = answerNotes
        self.sortOrder = sortOrder
        self.appointment = appointment
    }
}
