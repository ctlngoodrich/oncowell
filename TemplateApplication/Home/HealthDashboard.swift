//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziHealthKit
import SpeziHealthKitUI
import SwiftUI


enum TimeRange: String, CaseIterable {
    case week = "7 Days"
    case month = "30 Days"
    case threeMonths = "90 Days"

    var queryRange: HealthKitQueryTimeRange {
        switch self {
        case .week: .last(days: 7)
        case .month: .last(days: 30)
        case .threeMonths: .last(days: 90)
        }
    }
}


struct HealthDashboard: View {
    @State private var selectedRange: TimeRange = .week

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                timeRangePicker
                VitalsSection(timeRange: selectedRange)
                ActivitySection(timeRange: selectedRange)
                BodySection(timeRange: selectedRange)
            }
            .padding()
        }
        .navigationTitle("Health Dashboard")
    }

    private var timeRangePicker: some View {
        Picker("Time Range", selection: $selectedRange) {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(.segmented)
    }
}


#Preview {
    NavigationStack {
        HealthDashboard()
    }
    .previewWith(standard: TemplateApplicationStandard()) {
        HealthKit()
    }
}
