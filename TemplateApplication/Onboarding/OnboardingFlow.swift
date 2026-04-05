//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziHealthKit
import SpeziOnboarding
import SpeziViews
import SwiftUI


struct OnboardingFlow: View {
    @Environment(HealthKit.self) private var healthKit

    @AppStorage(StorageKeys.onboardingFlowComplete) private var completedOnboardingFlow = false


    @MainActor private var healthKitAvailable: Bool {
        if ProcessInfo.processInfo.isPreviewSimulator {
            return true
        }
        return HKHealthStore.isHealthDataAvailable()
    }

    @MainActor private var healthKitAuthorized: Bool {
        if ProcessInfo.processInfo.isPreviewSimulator {
            return false
        }
        return healthKit.isFullyAuthorized
    }

    var body: some View {
        ManagedNavigationStack(didComplete: $completedOnboardingFlow) {
            Welcome()
            if healthKitAvailable && !healthKitAuthorized {
                HealthKitPermissions()
            }
            DiagnosisContext()
        }
        .interactiveDismissDisabled(!completedOnboardingFlow)
    }
}


#Preview {
    OnboardingFlow()
        .previewWith(standard: TemplateApplicationStandard()) {
            HealthKit()
        }
        .modelContainer(for: PatientProfile.self, inMemory: true)
}
