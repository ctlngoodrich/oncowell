//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftData


enum AppointmentType: String, Codable, CaseIterable {
    case consultation = "Consultation"
    case treatment = "Treatment"
    case followUp = "Follow-Up"
    case imaging = "Imaging"
    case labWork = "Lab Work"
    case secondOpinion = "Second Opinion"
    case other = "Other"
}


enum AppointmentStatus: String, Codable, CaseIterable {
    case upcoming = "Upcoming"
    case completed = "Completed"
    case cancelled = "Cancelled"

    var systemImage: String {
        switch self {
        case .upcoming: "calendar.circle.fill"
        case .completed: "checkmark.circle.fill"
        case .cancelled: "xmark.circle.fill"
        }
    }
}


@Model
final class Appointment {
    var date: Date
    var providerName: String
    var facilityName: String
    var appointmentType: AppointmentType
    var status: AppointmentStatus
    var notes: String
    @Relationship(deleteRule: .cascade) var questions: [QuestionItem]
    @Relationship(deleteRule: .cascade) var recording: AppointmentRecording?

    init(
        date: Date = .now,
        providerName: String = "",
        facilityName: String = "",
        appointmentType: AppointmentType = .consultation,
        status: AppointmentStatus = .upcoming,
        notes: String = "",
        questions: [QuestionItem] = []
    ) {
        self.date = date
        self.providerName = providerName
        self.facilityName = facilityName
        self.appointmentType = appointmentType
        self.status = status
        self.notes = notes
        self.questions = questions
    }
}
