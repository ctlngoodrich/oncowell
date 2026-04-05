//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import AVFoundation
import Foundation


@Observable
final class AudioRecorderService {
    private(set) var isRecording = false
    private(set) var elapsedTime: TimeInterval = 0
    private(set) var audioFileURL: URL?

    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?


    static func deleteRecording(at url: URL) {
        try? FileManager.default.removeItem(at: url)
    }

    static func formattedTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func startRecording(fileName: String) throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .default)
        try session.setActive(true)

        let url = AppointmentRecording.recordingsDirectory
            .appendingPathComponent(fileName)

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        audioRecorder = try AVAudioRecorder(url: url, settings: settings)
        audioRecorder?.record()

        audioFileURL = url
        isRecording = true
        elapsedTime = 0

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { @Sendable [weak self] _ in
            self?.elapsedTime += 1
        }
    }

    func stopRecording() -> (url: URL, duration: TimeInterval)? {
        timer?.invalidate()
        timer = nil

        guard let recorder = audioRecorder else {
            return nil
        }
        let duration = recorder.currentTime
        recorder.stop()
        isRecording = false

        guard let url = audioFileURL else {
            return nil
        }
        return (url, duration)
    }
}
