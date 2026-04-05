//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation


// swiftlint:disable line_length

/// Static treatment content sourced from NCCN, AMA, and ACS guidelines.
/// All content is bundled with the app and does not require network access.
enum TreatmentContentStore {
    static let nccnSource = ContentSource(
        organization: "NCCN",
        guidelineName: "NCCN Guidelines for Patients",
        year: 2025,
        url: "https://www.nccn.org/patients"
    )

    static let acsSource = ContentSource(
        organization: "ACS",
        guidelineName: "American Cancer Society Treatment Guides",
        year: 2025,
        url: "https://www.cancer.org/treatment.html"
    )

    static let amaSource = ContentSource(
        organization: "AMA",
        guidelineName: "AMA Patient Resources",
        year: 2025,
        url: "https://www.ama-assn.org"
    )

    // MARK: - Surgery

    static let surgeryOverview = TreatmentArticle(
        id: "surgery-overview",
        title: "Surgery for Cancer",
        summary: "Surgery removes the tumor and some surrounding tissue. It is one of the oldest and most common cancer treatments.",
        sections: [
            ContentSection(
                id: "surgery-what",
                heading: "What Is Cancer Surgery?",
                body: "Cancer surgery is an operation to remove a tumor and some of the healthy tissue around it (called margins). The goal is to take out all the cancer while removing as little healthy tissue as possible. Surgery is often the first treatment for cancers that have not spread to other parts of the body."
            ),
            ContentSection(
                id: "surgery-types",
                heading: "Types of Surgery",
                body: "There are several approaches your surgeon may use:\n\n• Open surgery: A single larger cut to access and remove the tumor. This is the traditional approach.\n\n• Minimally invasive surgery: Several small cuts are made, and the surgeon uses special tools and a camera. This often means less pain and faster recovery.\n\n• Robotic surgery: Similar to minimally invasive, but the surgeon controls robotic arms for more precision.\n\nYour surgical oncologist will recommend the best approach based on your tumor size, location, and overall health."
            ),
            ContentSection(
                id: "surgery-what-to-expect",
                heading: "What to Expect",
                body: "Before surgery, you will have pre-operative tests and meet with your surgical team. Most cancer surgeries use general anesthesia, so you will be asleep during the procedure.\n\nThe length of surgery depends on the type and complexity — it can range from less than an hour to several hours. Afterward, you will spend time in a recovery area and may stay in the hospital for one or more days."
            ),
            ContentSection(
                id: "surgery-recovery",
                heading: "Recovery",
                body: "Recovery time varies depending on the type of surgery:\n\n• Minimally invasive: Often 1-3 weeks before returning to normal activities.\n\n• Open surgery: Typically 4-8 weeks for full recovery.\n\nDuring recovery, you may have activity restrictions (no heavy lifting, limited driving). Your surgical team will give you specific instructions. Pain is managed with medication and typically improves over the first 1-2 weeks."
            ),
            ContentSection(
                id: "surgery-side-effects",
                heading: "Possible Side Effects",
                body: "Like any operation, cancer surgery carries some risks:\n\n• Pain at the surgery site (usually temporary)\n• Fatigue\n• Risk of infection\n• Bleeding\n• Changes in function depending on what was removed\n\nMost side effects are temporary and improve as you heal. Your care team will monitor you closely and manage any complications."
            ),
            ContentSection(
                id: "surgery-outcomes",
                heading: "Outcomes",
                body: "For many early-stage cancers, surgery alone can be curative — meaning the cancer is completely removed. Your surgeon will check the margins (edges of the removed tissue) to confirm no cancer cells remain.\n\nIn some cases, additional treatment (adjuvant therapy) such as radiation or chemotherapy may be recommended after surgery to reduce the chance of the cancer coming back."
            )
        ],
        source: nccnSource,
        treatmentType: .surgery,
        category: .treatmentOverview,
        relatedTermIDs: ["surgical-oncologist", "general-anesthesia", "margins", "minimally-invasive", "adjuvant-therapy", "lymph-nodes", "staging"]
    )

    // MARK: - Radiation

    static let radiationOverview = TreatmentArticle(
        id: "radiation-overview",
        title: "Radiation Therapy for Cancer",
        summary: "Radiation therapy uses high-energy beams to kill cancer cells. It can be used as a primary treatment or alongside surgery.",
        sections: [
            ContentSection(
                id: "radiation-what",
                heading: "What Is Radiation Therapy?",
                body: "Radiation therapy uses high-energy beams (similar to X-rays but much stronger) to damage the DNA of cancer cells, causing them to stop growing and die. It is a localized treatment — it targets a specific area of your body, unlike chemotherapy which affects the whole body.\n\nAbout half of all cancer patients receive some form of radiation therapy."
            ),
            ContentSection(
                id: "radiation-types",
                heading: "Types of Radiation Therapy",
                body: "The two main types are:\n\n• External beam radiation: A machine outside your body directs radiation beams at the cancer. This is the most common type. You lie on a table and the machine moves around you. Each session is painless and typically lasts 15-30 minutes.\n\n• Brachytherapy (internal radiation): A radioactive source is placed inside your body, in or near the tumor. This delivers a high dose to a small area while reducing exposure to healthy tissue.\n\nYour radiation oncologist will recommend the best approach for your situation."
            ),
            ContentSection(
                id: "radiation-what-to-expect",
                heading: "What to Expect",
                body: "Before treatment begins, you will have a planning session (called simulation) where your radiation team maps the exact area to be treated using imaging scans. Small marks or tattoos may be placed on your skin to ensure precise targeting.\n\nExternal beam radiation is typically given 5 days a week for 3-9 weeks, depending on your treatment plan. Each visit is usually 15-30 minutes, though the actual radiation delivery takes only a few minutes.\n\nThe treatment itself is painless — you will not feel anything during each session."
            ),
            ContentSection(
                id: "radiation-recovery",
                heading: "Recovery",
                body: "Unlike surgery, radiation does not require a recovery period after each session — most people continue their daily activities during treatment.\n\nHowever, side effects tend to build up over the course of treatment and may continue for 1-2 weeks after your last session. Most side effects improve within a few weeks to months after treatment ends.\n\nYou will have regular follow-up appointments to monitor your recovery."
            ),
            ContentSection(
                id: "radiation-side-effects",
                heading: "Possible Side Effects",
                body: "Side effects depend on the area being treated and may include:\n\n• Skin changes in the treated area (redness, irritation, similar to sunburn)\n• Fatigue (often builds gradually during treatment)\n• Side effects specific to the body area being treated\n\nMost side effects are temporary. Your radiation oncologist can help manage them throughout treatment. Serious long-term side effects are uncommon but should be discussed with your doctor."
            ),
            ContentSection(
                id: "radiation-outcomes",
                heading: "Outcomes",
                body: "Radiation therapy can be highly effective, especially for localized cancers. It may be used as:\n\n• The primary treatment (instead of surgery)\n• After surgery (adjuvant) to eliminate remaining cancer cells\n• Before surgery (neoadjuvant) to shrink a tumor\n\nSuccess rates vary by cancer type, stage, and location. Your radiation oncologist can discuss expected outcomes for your specific situation."
            )
        ],
        source: nccnSource,
        treatmentType: .radiation,
        category: .treatmentOverview,
        relatedTermIDs: ["radiation-therapy", "radiation-oncologist", "external-beam", "brachytherapy", "adjuvant-therapy", "neoadjuvant-therapy", "staging", "recurrence"]
    )

    // MARK: - Comparison

    static let comparisonArticle = TreatmentArticle(
        id: "comparison",
        title: "Surgery vs. Radiation: Comparing Your Options",
        summary: "A side-by-side look at what each treatment involves, how recovery differs, and what to discuss with your doctor.",
        sections: [
            ContentSection(
                id: "compare-approach",
                heading: "How They Work",
                body: "Surgery physically removes the tumor from your body. Radiation kills cancer cells in place using high-energy beams.\n\nBoth can be curative for early-stage cancers. Your doctor may recommend one over the other based on your cancer type, location, stage, and overall health."
            ),
            ContentSection(
                id: "compare-timeline",
                heading: "Treatment Timeline",
                body: "Surgery: Usually a single procedure (one day), followed by a recovery period of 1-8 weeks depending on the approach.\n\nRadiation: Typically given over 3-9 weeks, with daily sessions on weekdays. Each session is short (15-30 minutes), and most people continue their daily routine during treatment."
            ),
            ContentSection(
                id: "compare-recovery",
                heading: "Recovery Comparison",
                body: "Surgery: Recovery involves managing post-operative pain, activity restrictions, and healing time. The initial recovery is more intensive, but once healed, treatment is complete.\n\nRadiation: No surgical recovery, but side effects (fatigue, skin changes) accumulate during treatment and may persist for weeks afterward. Daily treatment visits require a time commitment."
            ),
            ContentSection(
                id: "compare-side-effects",
                heading: "Side Effects Comparison",
                body: "Surgery side effects: Pain, fatigue, infection risk, and possible changes in function. These are typically short-term and improve as you heal.\n\nRadiation side effects: Skin irritation, fatigue, and area-specific effects. These build during treatment and usually resolve within weeks to months afterward.\n\nBoth treatments can have long-term effects — discuss these with your doctor."
            ),
            ContentSection(
                id: "compare-questions",
                heading: "Questions to Ask Your Doctor",
                body: "• Which treatment do you recommend for my specific cancer, and why?\n• What are the expected cure rates for each option in my situation?\n• What are the short-term and long-term side effects I should expect?\n• How will each option affect my daily life during and after treatment?\n• Can I get a second opinion before deciding?\n• Is there a benefit to combining both treatments?"
            )
        ],
        source: nccnSource,
        treatmentType: .general,
        category: .treatmentOverview,
        relatedTermIDs: ["oncologist", "second-opinion", "recurrence"]
    )

    // MARK: - Provider Evaluation

    static let providerEvaluation = TreatmentArticle(
        id: "provider-evaluation",
        title: "Choosing Where to Get Care",
        summary: "What to look for in a cancer care provider and how to evaluate your options.",
        sections: [
            ContentSection(
                id: "provider-what-matters",
                heading: "What Matters When Choosing a Provider",
                body: "Not all cancer treatment facilities are the same. Research shows that outcomes can be better at centers that treat a high volume of your specific cancer type. Here are the key factors to consider:\n\n• Experience with your cancer type\n• Whether the facility has a multidisciplinary tumor board\n• Whether it is accredited by recognized cancer organizations\n• Your comfort level with the care team\n• Practical factors like location and insurance coverage"
            ),
            ContentSection(
                id: "provider-academic-vs-community",
                heading: "Academic Medical Centers vs. Community Hospitals",
                body: "Academic medical centers (like university hospitals) often have:\n• Access to the latest clinical trials\n• Specialists focused on specific cancer types\n• Multidisciplinary tumor boards where multiple experts discuss your case\n• Research-based treatment approaches\n\nCommunity hospitals may offer:\n• Closer to home (less travel)\n• More personal attention and shorter wait times\n• Strong general oncology care\n\nFor complex or rare cancers, academic centers may offer advantages. For more common cancers with established treatment plans, community hospitals can provide excellent care. Many patients get opinions from both."
            ),
            ContentSection(
                id: "provider-questions",
                heading: "Questions to Ask a Potential Provider",
                body: "• How many patients with my type of cancer do you treat each year?\n• Do you have a tumor board that will review my case?\n• What treatment approach do you recommend, and why?\n• Are there clinical trials available for my situation?\n• Who else will be part of my care team?\n• How will I communicate with my care team between visits?\n• What support services are available (nutrition, social work, navigation)?"
            ),
            ContentSection(
                id: "provider-second-opinion",
                heading: "Getting a Second Opinion",
                body: "Getting a second opinion is common, encouraged, and will not offend your current doctor. A second opinion can:\n\n• Confirm your current treatment plan (giving you more confidence)\n• Offer alternative treatment options you had not considered\n• Provide access to different clinical trials\n\nMost insurance plans cover second opinions. Ask your current doctor for your records and imaging to bring to the second appointment."
            ),
            ContentSection(
                id: "provider-accreditation",
                heading: "Accreditation and Quality Markers",
                body: "Look for these quality markers:\n\n• NCI-Designated Cancer Center: Designated by the National Cancer Institute for scientific leadership and resources. There are about 72 in the US.\n\n• NCCN Member Institution: One of 33 leading cancer centers that develop the NCCN treatment guidelines.\n\n• Commission on Cancer (CoC) Accreditation: An ACS quality program that accredits over 1,500 facilities meeting standards for comprehensive cancer care.\n\nYou can search for accredited centers on the ACS, NCCN, and NCI websites."
            )
        ],
        source: acsSource,
        treatmentType: .general,
        category: .providerSelection,
        relatedTermIDs: ["oncologist", "tumor-board", "second-opinion"]
    )

    // MARK: - Access

    static let allArticles: [TreatmentArticle] = [
        surgeryOverview,
        radiationOverview,
        comparisonArticle,
        providerEvaluation
    ]

    static func article(byID id: String) -> TreatmentArticle? {
        allArticles.first { $0.id == id }
    }
}

// swiftlint:enable line_length
