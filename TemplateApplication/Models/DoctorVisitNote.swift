//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftData


enum VisitType: String, Codable, CaseIterable {
    case consultation = "Consultation"
    case followUp = "Follow-Up"
    case secondOpinion = "Second Opinion"
    case imaging = "Imaging"
    case labWork = "Lab Work"
    case treatment = "Treatment"
    case other = "Other"
}


@Model
final class DoctorVisitNote {
    var date: Date
    var providerName: String
    var facilityName: String
    var visitType: VisitType
    var summary: String
    var decisionsAndNextSteps: String

    init(
        date: Date = .now,
        providerName: String = "",
        facilityName: String = "",
        visitType: VisitType = .consultation,
        summary: String = "",
        decisionsAndNextSteps: String = ""
    ) {
        self.date = date
        self.providerName = providerName
        self.facilityName = facilityName
        self.visitType = visitType
        self.summary = summary
        self.decisionsAndNextSteps = decisionsAndNextSteps
    }
}
