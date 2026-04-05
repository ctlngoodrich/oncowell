//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftData


@Model
final class TranscriptSummary {
    var plainLanguageSummary: String
    var decisions: [String]
    var nextSteps: [String]
    var medicationsDiscussed: [String]
    var followUpInstructions: [String]
    var userAnnotations: String
    var generatedDate: Date

    @Relationship(inverse: \AppointmentRecording.summary) var recording: AppointmentRecording?

    init(
        plainLanguageSummary: String = "",
        decisions: [String] = [],
        nextSteps: [String] = [],
        medicationsDiscussed: [String] = [],
        followUpInstructions: [String] = [],
        userAnnotations: String = "",
        generatedDate: Date = .now,
        recording: AppointmentRecording? = nil
    ) {
        self.plainLanguageSummary = plainLanguageSummary
        self.decisions = decisions
        self.nextSteps = nextSteps
        self.medicationsDiscussed = medicationsDiscussed
        self.followUpInstructions = followUpInstructions
        self.userAnnotations = userAnnotations
        self.generatedDate = generatedDate
        self.recording = recording
    }
}
