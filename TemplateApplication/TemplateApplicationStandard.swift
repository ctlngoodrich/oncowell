//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import OSLog
import Spezi
import SpeziHealthKit


actor TemplateApplicationStandard: Standard, EnvironmentAccessible, HealthKitConstraint {
    @Application(\.logger) private var logger


    init() {}


    func handleNewSamples<Sample>(
        _ addedSamples: some Collection<Sample>,
        ofType sampleType: SampleType<Sample>
    ) async {
        for sample in addedSamples {
            logger.debug("Received new HealthKit sample: \(sample)")
        }
    }

    func handleDeletedObjects<Sample>(
        _ deletedObjects: some Collection<HKDeletedObject>,
        ofType sampleType: SampleType<Sample>
    ) async {
        for object in deletedObjects {
            logger.debug("HealthKit sample removed: \(object.uuid)")
        }
    }
}
