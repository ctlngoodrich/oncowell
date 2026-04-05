//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation

#if canImport(FoundationModels)
import FoundationModels
#endif


// swiftlint:disable:next file_types_order
enum TranscriptIntelligenceService {
    static var isAvailable: Bool {
        guard #available(iOS 26.0, *) else {
            return false
        }
        return SystemLanguageModel.default.availability == .available
    }

    private static var instructions: String {
        "You are a helpful medical appointment assistant. "
        + "Your job is to analyze doctor appointment transcripts and extract "
        + "key information in plain language that a patient can understand. "
        + "Be accurate and only include information that was actually discussed. "
        + "If a category has no relevant information, return an empty list. "
        + "Use simple, non-technical language when possible."
    }

    static func analyze(transcript: String) async throws -> TranscriptSummaryResult {
        guard #available(iOS 26.0, *) else {
            throw IntelligenceError.unavailable
        }
        return try await analyzeWithFoundationModels(transcript: transcript)
    }

    @available(iOS 26.0, *)
    private static func analyzeWithFoundationModels(
        transcript: String
    ) async throws -> TranscriptSummaryResult {
        let session = LanguageModelSession(instructions: instructions)

        let prompt = "Here is a transcript of a doctor appointment. "
            + "Please analyze it and extract the key information:\n\n"
            + transcript

        let response = try await session.respond(
            to: prompt,
            generating: TranscriptAnalysis.self
        )

        let analysis = response.content
        return TranscriptSummaryResult(
            summary: analysis.summary,
            decisions: analysis.decisions,
            nextSteps: analysis.nextSteps,
            medicationsDiscussed: analysis.medicationsDiscussed,
            followUpInstructions: analysis.followUpInstructions
        )
    }
}


// swiftlint:disable attributes
@available(iOS 26.0, *)
@Generable
struct TranscriptAnalysis {
    @Guide(description: "A plain-language summary of the appointment in 3-5 sentences, written for a patient to understand")
    var summary: String

    @Guide(description: "Key decisions made during the appointment, each as a short sentence")
    var decisions: [String]

    @Guide(description: "Next steps or action items discussed, each as a short sentence")
    var nextSteps: [String]

    @Guide(description: "Names of any medications discussed during the appointment")
    var medicationsDiscussed: [String]

    @Guide(description: "Follow-up instructions from the doctor, each as a short sentence")
    var followUpInstructions: [String]
}
// swiftlint:enable attributes


struct TranscriptSummaryResult {
    let summary: String
    let decisions: [String]
    let nextSteps: [String]
    let medicationsDiscussed: [String]
    let followUpInstructions: [String]
}


enum IntelligenceError: LocalizedError {
    case unavailable

    var errorDescription: String? {
        "On-device AI is not available on this device."
    }
}
