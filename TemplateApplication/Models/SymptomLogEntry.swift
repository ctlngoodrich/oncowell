//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftData


enum SymptomType: String, Codable, CaseIterable {
    case pain = "Pain"
    case fatigue = "Fatigue"
    case nausea = "Nausea"
    case appetiteChanges = "Appetite Changes"
    case sleepDifficulty = "Sleep Difficulty"
    case mood = "Mood Changes"
    case other = "Other"
}


enum SymptomSeverity: Int, Codable, CaseIterable {
    case mild = 1
    case moderate = 2
    case severe = 3

    var label: String {
        switch self {
        case .mild: "Mild"
        case .moderate: "Moderate"
        case .severe: "Severe"
        }
    }

    var color: String {
        switch self {
        case .mild: "green"
        case .moderate: "orange"
        case .severe: "red"
        }
    }
}


@Model
final class SymptomLogEntry {
    var date: Date
    var symptomType: SymptomType
    var severity: SymptomSeverity
    var bodyLocation: String
    var notes: String

    init(
        date: Date = .now,
        symptomType: SymptomType = .pain,
        severity: SymptomSeverity = .moderate,
        bodyLocation: String = "",
        notes: String = ""
    ) {
        self.date = date
        self.symptomType = symptomType
        self.severity = severity
        self.bodyLocation = bodyLocation
        self.notes = notes
    }
}
