//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftData


enum CancerType: String, Codable, CaseIterable {
    case prostate = "Prostate"
    case lung = "Lung"
    case breast = "Breast"
    case colorectal = "Colorectal"
    case bladder = "Bladder"
    case kidney = "Kidney"
    case other = "Other"
}


enum CancerStage: String, Codable, CaseIterable {
    case early = "Early (Stage I-II)"
    case locallyAdvanced = "Locally Advanced (Stage III)"
    case advanced = "Advanced (Stage IV)"
    case unsure = "Not sure"
}


enum TreatmentStatus: String, Codable, CaseIterable {
    case newlyDiagnosed = "Newly diagnosed"
    case decidingTreatment = "Deciding on treatment"
    case inTreatment = "Currently in treatment"
    case postTreatment = "Finished treatment"
}


@Model
final class PatientProfile {
    var name: String
    var dateOfBirth: Date?
    var cancerType: CancerType?
    var cancerStage: CancerStage?
    var diagnosisDate: Date?
    var treatmentStatus: TreatmentStatus?

    init(
        name: String = "",
        dateOfBirth: Date? = nil,
        cancerType: CancerType? = nil,
        cancerStage: CancerStage? = nil,
        diagnosisDate: Date? = nil,
        treatmentStatus: TreatmentStatus? = nil
    ) {
        self.name = name
        self.dateOfBirth = dateOfBirth
        self.cancerType = cancerType
        self.cancerStage = cancerStage
        self.diagnosisDate = diagnosisDate
        self.treatmentStatus = treatmentStatus
    }
}
