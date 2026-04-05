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
final class TranscriptSegment {
    var text: String
    var timestamp: TimeInterval

    init(text: String, timestamp: TimeInterval) {
        self.text = text
        self.timestamp = timestamp
    }
}


@Model
final class AppointmentRecording {
    static var recordingsDirectory: URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dir = docs.appendingPathComponent("Recordings", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    var date: Date
    var duration: TimeInterval
    var audioFileName: String
    var transcriptText: String
    @Relationship(deleteRule: .cascade) var segments: [TranscriptSegment]
    var isTranscribing: Bool
    @Relationship(deleteRule: .cascade) var summary: TranscriptSummary?

    @Relationship(inverse: \Appointment.recording) var appointment: Appointment?

    var audioFileURL: URL? {
        guard !audioFileName.isEmpty else {
            return nil
        }
        return Self.recordingsDirectory.appendingPathComponent(audioFileName)
    }

    init(
        date: Date = .now,
        duration: TimeInterval = 0,
        audioFileName: String = "",
        transcriptText: String = "",
        segments: [TranscriptSegment] = [],
        isTranscribing: Bool = false,
        appointment: Appointment? = nil
    ) {
        self.date = date
        self.duration = duration
        self.audioFileName = audioFileName
        self.transcriptText = transcriptText
        self.segments = segments
        self.isTranscribing = isTranscribing
        self.appointment = appointment
    }
}
