//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import Speech


// swiftlint:disable:next file_types_order
enum TranscriptionService {
    static func requestAuthorization() async -> Bool {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }

    static func transcribe(audioURL: URL) async throws -> TranscriptionResult {
        guard let recognizer = SFSpeechRecognizer() else {
            throw TranscriptionError.recognizerUnavailable
        }

        guard recognizer.isAvailable else {
            throw TranscriptionError.recognizerUnavailable
        }

        let request = SFSpeechURLRecognitionRequest(url: audioURL)
        request.requiresOnDeviceRecognition = true
        request.shouldReportPartialResults = false

        return try await withCheckedThrowingContinuation { continuation in
            recognizer.recognitionTask(with: request) { result, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let result, result.isFinal else {
                    return
                }

                let fullText = result.bestTranscription.formattedString
                let segments: [(String, TimeInterval)] = result.bestTranscription.segments.map {
                    ($0.substring, $0.timestamp)
                }
                let transcription = TranscriptionResult(fullText: fullText, segments: segments)
                continuation.resume(returning: transcription)
            }
        }
    }
}


struct TranscriptionResult {
    let fullText: String
    let segments: [(text: String, timestamp: TimeInterval)]
}


enum TranscriptionError: LocalizedError {
    case recognizerUnavailable
    case noResult

    var errorDescription: String? {
        switch self {
        case .recognizerUnavailable:
            "Speech recognition is not available on this device."
        case .noResult:
            "Could not generate a transcription."
        }
    }
}
