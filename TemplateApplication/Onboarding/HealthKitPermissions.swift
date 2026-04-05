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


struct HealthKitPermissions: View {
    @Environment(HealthKit.self) private var healthKit
    @Environment(ManagedNavigationStack.Path.self) private var path


    var body: some View {
        OnboardingView(
            title: "Health Data",
            subtitle: "OncoWell can read your health data from Apple Health to show your vitals alongside your treatment options.",
            areas: areas,
            actionText: "Allow Access",
            action: {
                try await healthKit.askForAuthorization()
                path.nextStep()
            }
        )
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Skip") {
                    path.nextStep()
                }
            }
        }
    }

    private var areas: [OnboardingInformationView.Area] {
        [
            OnboardingInformationView.Area(
                icon: {
                    Image(systemName: "heart.fill")
                        .accessibilityHidden(true)
                },
                title: "Vitals",
                description: "Heart rate, blood pressure, and resting heart rate."
            ),
            OnboardingInformationView.Area(
                icon: {
                    Image(systemName: "figure.walk")
                        .accessibilityHidden(true)
                },
                title: "Activity",
                description: "Steps, exercise minutes, and active energy."
            ),
            OnboardingInformationView.Area(
                icon: {
                    Image(systemName: "bed.double.fill")
                        .accessibilityHidden(true)
                },
                title: "Body and Sleep",
                description: "Weight, BMI, and sleep data."
            )
        ]
    }
}


#Preview {
    ManagedNavigationStack {
        HealthKitPermissions()
    }
        .previewWith(standard: TemplateApplicationStandard()) {
            HealthKit()
        }
}
