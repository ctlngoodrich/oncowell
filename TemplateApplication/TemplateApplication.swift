//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziViews
import SwiftData
import SwiftUI


@main
struct TemplateApplication: App {
    @UIApplicationDelegateAdaptor(TemplateApplicationDelegate.self) var appDelegate
    @AppStorage(StorageKeys.onboardingFlowComplete) var completedOnboardingFlow = false


    var body: some Scene {
        WindowGroup {
            ZStack {
                if completedOnboardingFlow {
                    HomeView()
                } else {
                    EmptyView()
                }
            }
            .sheet(isPresented: !$completedOnboardingFlow) {
                OnboardingFlow()
            }
            .testingSetup()
            .spezi(appDelegate)
        }
        .modelContainer(
            for: [
                PatientProfile.self,
                SymptomLogEntry.self,
                TestResult.self,
                DoctorVisitNote.self,
                Appointment.self,
                QuestionItem.self,
                AppointmentRecording.self,
                TranscriptSegment.self,
                TranscriptSummary.self
            ]
        )
    }
}
