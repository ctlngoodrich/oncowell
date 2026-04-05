//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftData


enum TestType: String, Codable, CaseIterable {
    case psa = "PSA"
    case cbc = "CBC (Complete Blood Count)"
    case metabolicPanel = "Metabolic Panel"
    case ctScan = "CT Scan"
    case mri = "MRI"
    case petScan = "PET Scan"
    case biopsy = "Biopsy / Pathology"
    case gleasonScore = "Gleason Score"
    case other = "Other"

    var suggestedUnit: String {
        switch self {
        case .psa: "ng/mL"
        case .cbc: "cells/mcL"
        case .metabolicPanel: "mg/dL"
        case .ctScan, .mri, .petScan, .biopsy: ""
        case .gleasonScore: ""
        case .other: ""
        }
    }
}


@Model
final class TestResult {
    var date: Date
    var testType: TestType
    var testName: String
    var value: String
    var unit: String
    var referenceRange: String
    var notes: String

    init(
        date: Date = .now,
        testType: TestType = .psa,
        testName: String = "",
        value: String = "",
        unit: String = "",
        referenceRange: String = "",
        notes: String = ""
    ) {
        self.date = date
        self.testType = testType
        self.testName = testName
        self.value = value
        self.unit = unit
        self.referenceRange = referenceRange
        self.notes = notes
    }
}
