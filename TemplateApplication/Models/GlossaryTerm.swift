//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation


struct GlossaryTerm: Identifiable {
    let id: String
    let term: String
    let definition: String
    let source: String
    let relatedArticleIDs: [String]
}
