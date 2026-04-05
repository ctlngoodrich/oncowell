//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation


// swiftlint:disable line_length

/// Glossary of medical terms used in treatment content.
/// Sources: NCCN Guidelines for Patients, ACS Cancer Glossary, AMA Patient Resources.
enum GlossaryContent {
    static let allTerms: [GlossaryTerm] = [
        GlossaryTerm(
            id: "biopsy",
            term: "Biopsy",
            definition: "A procedure where a small sample of tissue is removed from the body and examined under a microscope to check for cancer or other conditions.",
            source: "ACS",
            relatedArticleIDs: ["surgery-overview", "radiation-overview"]
        ),
        GlossaryTerm(
            id: "malignant",
            term: "Malignant",
            definition: "Cancerous. Malignant cells can grow uncontrollably and spread to other parts of the body.",
            source: "ACS",
            relatedArticleIDs: []
        ),
        GlossaryTerm(
            id: "benign",
            term: "Benign",
            definition: "Not cancerous. Benign tumors do not spread to other parts of the body.",
            source: "ACS",
            relatedArticleIDs: []
        ),
        GlossaryTerm(
            id: "oncologist",
            term: "Oncologist",
            definition: "A doctor who specializes in treating cancer. There are different types: medical oncologists (drug treatments), surgical oncologists (surgery), and radiation oncologists (radiation therapy).",
            source: "ACS",
            relatedArticleIDs: ["provider-evaluation"]
        ),
        GlossaryTerm(
            id: "radiation-oncologist",
            term: "Radiation Oncologist",
            definition: "A doctor who specializes in using radiation to treat cancer. They plan and oversee your radiation therapy.",
            source: "NCCN",
            relatedArticleIDs: ["radiation-overview"]
        ),
        GlossaryTerm(
            id: "surgical-oncologist",
            term: "Surgical Oncologist",
            definition: "A surgeon who specializes in removing cancerous tumors and nearby tissue during an operation.",
            source: "NCCN",
            relatedArticleIDs: ["surgery-overview"]
        ),
        GlossaryTerm(
            id: "tumor",
            term: "Tumor",
            definition: "An abnormal mass of tissue. Tumors can be benign (not cancer) or malignant (cancer).",
            source: "ACS",
            relatedArticleIDs: []
        ),
        GlossaryTerm(
            id: "staging",
            term: "Staging",
            definition: "The process of finding out how much cancer is in the body and where it is located. Staging helps determine the best treatment approach. Stages range from I (early) to IV (advanced).",
            source: "NCCN",
            relatedArticleIDs: ["surgery-overview", "radiation-overview"]
        ),
        GlossaryTerm(
            id: "lymph-nodes",
            term: "Lymph Nodes",
            definition: "Small, bean-shaped organs that are part of the immune system. During cancer surgery, nearby lymph nodes may be removed to check if cancer has spread.",
            source: "ACS",
            relatedArticleIDs: ["surgery-overview"]
        ),
        GlossaryTerm(
            id: "general-anesthesia",
            term: "General Anesthesia",
            definition: "Medicine that puts you into a deep sleep during surgery so you do not feel pain. You will not be awake or aware during the procedure.",
            source: "AMA",
            relatedArticleIDs: ["surgery-overview"]
        ),
        GlossaryTerm(
            id: "radiation-therapy",
            term: "Radiation Therapy",
            definition: "A treatment that uses high-energy beams (like X-rays) to kill cancer cells or stop them from growing. It can be delivered from outside the body (external beam) or from inside the body (brachytherapy).",
            source: "NCCN",
            relatedArticleIDs: ["radiation-overview"]
        ),
        GlossaryTerm(
            id: "external-beam",
            term: "External Beam Radiation",
            definition: "A type of radiation therapy where a machine outside the body aims radiation beams at the cancer. Treatment is usually given 5 days a week for several weeks.",
            source: "NCCN",
            relatedArticleIDs: ["radiation-overview"]
        ),
        GlossaryTerm(
            id: "brachytherapy",
            term: "Brachytherapy",
            definition: "A type of radiation therapy where a radioactive source is placed inside the body, directly in or near the tumor. This allows a high dose of radiation to a small area.",
            source: "NCCN",
            relatedArticleIDs: ["radiation-overview"]
        ),
        GlossaryTerm(
            id: "margins",
            term: "Margins",
            definition: "The edge of the tissue removed during surgery. If the margins are 'clear' or 'negative,' no cancer cells were found at the edges, which is a good sign.",
            source: "ACS",
            relatedArticleIDs: ["surgery-overview"]
        ),
        GlossaryTerm(
            id: "tumor-board",
            term: "Tumor Board",
            definition: "A group of doctors and other health care providers from different specialties who meet regularly to discuss cancer cases and recommend treatment plans together.",
            source: "NCCN",
            relatedArticleIDs: ["provider-evaluation"]
        ),
        GlossaryTerm(
            id: "recurrence",
            term: "Recurrence",
            definition: "When cancer comes back after treatment. It can come back in the same place (local recurrence) or in a different part of the body (distant recurrence).",
            source: "ACS",
            relatedArticleIDs: ["surgery-overview", "radiation-overview"]
        ),
        GlossaryTerm(
            id: "second-opinion",
            term: "Second Opinion",
            definition: "When you see another doctor to get their view on your diagnosis and treatment options. Getting a second opinion is common and encouraged — it can confirm your plan or offer new options.",
            source: "AMA",
            relatedArticleIDs: ["provider-evaluation"]
        ),
        GlossaryTerm(
            id: "minimally-invasive",
            term: "Minimally Invasive Surgery",
            definition: "Surgery done through small cuts instead of one large opening. This often means less pain, smaller scars, and a faster recovery compared to traditional open surgery.",
            source: "AMA",
            relatedArticleIDs: ["surgery-overview"]
        ),
        GlossaryTerm(
            id: "adjuvant-therapy",
            term: "Adjuvant Therapy",
            definition: "Additional treatment given after the main treatment (usually surgery) to lower the chance that cancer will come back. This can include radiation, chemotherapy, or other treatments.",
            source: "NCCN",
            relatedArticleIDs: ["surgery-overview", "radiation-overview"]
        ),
        GlossaryTerm(
            id: "neoadjuvant-therapy",
            term: "Neoadjuvant Therapy",
            definition: "Treatment given before the main treatment (usually surgery) to shrink a tumor and make it easier to remove.",
            source: "NCCN",
            relatedArticleIDs: ["surgery-overview"]
        )
    ]

    static func term(byID id: String) -> GlossaryTerm? {
        allTerms.first { $0.id == id }
    }

    static func terms(matching query: String) -> [GlossaryTerm] {
        let lowered = query.lowercased()
        return allTerms.filter {
            $0.term.lowercased().contains(lowered)
                || $0.definition.lowercased().contains(lowered)
        }
    }
}

// swiftlint:enable line_length
