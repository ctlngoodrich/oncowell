//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziHealthKit
import SwiftUI


class TemplateApplicationDelegate: SpeziAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: TemplateApplicationStandard()) {
            healthKit
        }
    }

    private var healthKit: HealthKit {
        HealthKit {
            CollectSamples(.stepCount)
            CollectSamples(.heartRate)
            CollectSamples(.restingHeartRate)
            CollectSamples(.bodyMass)
            CollectSamples(.bodyMassIndex)
            CollectSamples(.activeEnergyBurned)
            CollectSamples(.appleExerciseTime)
            CollectSamples(.bloodPressureSystolic)
            CollectSamples(.bloodPressureDiastolic)
        }
    }
}
