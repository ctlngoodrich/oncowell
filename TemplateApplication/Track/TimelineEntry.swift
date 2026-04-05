//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation


enum TimelineEntry: Identifiable {
    case symptom(SymptomLogEntry)
    case testResult(TestResult)
    case visitNote(DoctorVisitNote)

    var id: String {
        switch self {
        case .symptom(let entry):
            "symptom-\(entry.persistentModelID.hashValue)"
        case .testResult(let result):
            "test-\(result.persistentModelID.hashValue)"
        case .visitNote(let note):
            "visit-\(note.persistentModelID.hashValue)"
        }
    }

    var date: Date {
        switch self {
        case .symptom(let entry): entry.date
        case .testResult(let result): result.date
        case .visitNote(let note): note.date
        }
    }
}
