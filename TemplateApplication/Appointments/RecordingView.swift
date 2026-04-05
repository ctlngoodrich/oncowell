//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftData
import SwiftUI


struct RecordingView: View {
    @Environment(\.modelContext) private var modelContext
    let appointment: Appointment

    @State private var recorder = AudioRecorderService()
    @State private var showingConsentAlert = false
    @State private var isTranscribing = false
    @State private var errorMessage: String?


    var body: some View {
        VStack(spacing: 24) {
            if let recording = appointment.recording {
                existingRecording(recording)
            } else if recorder.isRecording {
                activeRecording
            } else {
                startPrompt
            }
        }
        .padding()
        .navigationTitle("Recording")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Before You Record", isPresented: $showingConsentAlert) {
            Button("I've Informed My Provider", action: beginRecording)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text(consentMessage)
        }
        .alert("Error", isPresented: showingError) {
            Button("OK") { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }

    private var consentMessage: String {
        "Please inform your healthcare provider before recording. "
        + "Recording laws vary by state — many require all-party consent."
    }

    private var showingError: Binding<Bool> {
        Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })
    }

    private var startPrompt: some View {
        VStack(spacing: 16) {
            Image(systemName: "mic.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.red)
                .accessibilityHidden(true)
            Text("Record Your Appointment")
                .font(.title3)
                .fontWeight(.semibold)
            Text(recordingExplanation)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button {
                showingConsentAlert = true
            } label: {
                Label("Start Recording", systemImage: "mic.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
    }

    private var recordingExplanation: String {
        "Record your appointment so you can review what was discussed. "
        + "The audio stays on your device and is transcribed locally."
    }

    private var activeRecording: some View {
        VStack(spacing: 20) {
            recordingIndicator
            Text(AudioRecorderService.formattedTime(recorder.elapsedTime))
                .font(.system(size: 48, weight: .light, design: .monospaced))
                .monospacedDigit()
            Button(action: stopAndTranscribe) {
                Label("Stop Recording", systemImage: "stop.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
    }

    private var recordingIndicator: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(.red)
                .frame(width: 12, height: 12)
            Text("Recording")
                .font(.headline)
                .foregroundStyle(.red)
        }
    }

    private var transcribingMessage: String {
        "This may take a moment. Transcription happens entirely on your device."
    }

    private func existingRecording(_ recording: AppointmentRecording) -> some View {
        VStack(spacing: 16) {
            if recording.isTranscribing || isTranscribing {
                transcribingIndicator(recording)
            } else if !recording.transcriptText.isEmpty {
                transcriptLink(recording)
            } else {
                recordingComplete(recording)
            }
            deleteButton(recording)
        }
    }

    private func transcribingIndicator(_ recording: AppointmentRecording) -> some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Transcribing...")
                .font(.headline)
            Text(transcribingMessage)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private func transcriptLink(_ recording: AppointmentRecording) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 40))
                .foregroundStyle(.green)
                .accessibilityHidden(true)
            Text("Recording Complete")
                .font(.headline)
            durationLabel(recording.duration)
            NavigationLink {
                TranscriptView(recording: recording)
            } label: {
                Label("View Transcript", systemImage: "doc.text")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private func recordingComplete(_ recording: AppointmentRecording) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "waveform")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            Text("Recording Saved")
                .font(.headline)
            durationLabel(recording.duration)
            Button(action: { transcribeExisting(recording) }) {
                Label("Transcribe", systemImage: "text.bubble")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private func durationLabel(_ duration: TimeInterval) -> some View {
        Text("Duration: \(AudioRecorderService.formattedTime(duration))")
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }

    private func deleteButton(_ recording: AppointmentRecording) -> some View {
        Button(role: .destructive) {
            deleteRecording(recording)
        } label: {
            Label("Delete Recording", systemImage: "trash")
        }
    }

    private func beginRecording() {
        do {
            let fileName = "recording-\(UUID().uuidString).m4a"
            try recorder.startRecording(fileName: fileName)
        } catch {
            errorMessage = "Could not start recording: \(error.localizedDescription)"
        }
    }

    private func stopAndTranscribe() {
        guard let result = recorder.stopRecording() else {
            return
        }

        let recording = AppointmentRecording(
            date: .now,
            duration: result.duration,
            audioFileName: result.url.lastPathComponent,
            isTranscribing: true,
            appointment: appointment
        )
        modelContext.insert(recording)

        Task {
            await transcribe(recording: recording, url: result.url)
        }
    }

    private func transcribeExisting(_ recording: AppointmentRecording) {
        guard let url = recording.audioFileURL else {
            return
        }
        recording.isTranscribing = true
        isTranscribing = true
        Task {
            await transcribe(recording: recording, url: url)
        }
    }

    private func transcribe(recording: AppointmentRecording, url: URL) async {
        let authorized = await TranscriptionService.requestAuthorization()
        guard authorized else {
            await MainActor.run {
                recording.isTranscribing = false
                isTranscribing = false
                errorMessage = "Speech recognition permission was denied."
            }
            return
        }

        do {
            let result = try await TranscriptionService.transcribe(audioURL: url)
            await MainActor.run {
                recording.transcriptText = result.fullText
                for segment in result.segments {
                    let seg = TranscriptSegment(text: segment.text, timestamp: segment.timestamp)
                    recording.segments.append(seg)
                }
                recording.isTranscribing = false
                isTranscribing = false
            }
        } catch {
            await MainActor.run {
                recording.isTranscribing = false
                isTranscribing = false
                errorMessage = "Transcription failed: \(error.localizedDescription)"
            }
        }
    }

    private func deleteRecording(_ recording: AppointmentRecording) {
        if let url = recording.audioFileURL {
            AudioRecorderService.deleteRecording(at: url)
        }
        modelContext.delete(recording)
    }
}
