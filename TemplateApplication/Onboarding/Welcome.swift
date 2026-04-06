//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziOnboarding
import SpeziViews
import SwiftUI


struct Welcome: View {
    @Environment(ManagedNavigationStack.Path.self) private var managedNavigationPath


    var body: some View {
        VStack(spacing: 0) {
            Image("OncoWellLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
                .accessibilityHidden(true)
                .padding(.top, 32)
            OnboardingView(
                title: "OncoWell",
                subtitle: welcomeSubtitle,
                areas: onboardingAreas,
                actionText: "Get Started",
                action: {
                    managedNavigationPath.nextStep()
                }
            )
        }
    }

    private var welcomeSubtitle: String {
        "Understand your treatment options, track your health, "
        + "and prepare for your next appointment."
    }

    private var onboardingAreas: [OnboardingInformationView.Area] {
        [
            OnboardingInformationView.Area(
                icon: {
                    Image(systemName: "book.fill")
                        .accessibilityHidden(true)
                },
                title: "Learn About Your Options",
                description: "Compare surgery and radiation therapy with trusted "
                    + "information from NCCN, AMA, and ACS."
            ),
            OnboardingInformationView.Area(
                icon: {
                    Image(systemName: "heart.text.square.fill")
                        .accessibilityHidden(true)
                },
                title: "Track Your Health",
                description: "View your vitals from Apple Health, log symptoms, "
                    + "and record test results — all in one place."
            ),
            OnboardingInformationView.Area(
                icon: {
                    Image(systemName: "questionmark.bubble.fill")
                        .accessibilityHidden(true)
                },
                title: "Prepare for Appointments",
                description: "Build a list of informed questions, record your "
                    + "doctor visits, and review what was discussed."
            )
        ]
    }
}


#Preview {
    ManagedNavigationStack {
        Welcome()
    }
}
