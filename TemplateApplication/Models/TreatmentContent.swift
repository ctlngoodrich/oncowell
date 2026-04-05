//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation


enum ContentCategory: String, Codable {
    case treatmentOverview
    case sideEffects
    case recovery
    case providerSelection
}


enum TreatmentType: String, Codable {
    case surgery
    case radiation
    case general
}


struct ContentSection: Identifiable {
    let id: String
    let heading: String
    let body: String
}


struct ContentSource {
    let organization: String
    let guidelineName: String
    let year: Int
    let url: String?
}


struct TreatmentArticle: Identifiable {
    let id: String
    let title: String
    let summary: String
    let sections: [ContentSection]
    let source: ContentSource
    let treatmentType: TreatmentType
    let category: ContentCategory
    let relatedTermIDs: [String]
}
