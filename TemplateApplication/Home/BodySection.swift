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


struct BodySection: View {
    let timeRange: TimeRange

    @HealthKitQuery(.bodyMass, timeRange: .last(days: 7)) private var weightSamples


    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Body Measurements", systemImage: "figure")
                .font(.headline)
                .foregroundStyle(.purple)
            weightCard
        }
    }

    private var weightCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Weight")
                .font(.subheadline)
                .fontWeight(.semibold)
            latestWeight
            HealthChart {
                HealthChartEntry(
                    $weightSamples,
                    drawingConfig: .init(chartType: .line, color: .purple)
                )
            }
            .frame(height: 150)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }

    private var latestWeight: some View {
        Group {
            if let latest = weightSamples.last {
                let lbs = latest.quantity.doubleValue(for: .pound())
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(format: "%.1f", lbs))
                        .font(.title)
                        .fontWeight(.bold)
                        .monospacedDigit()
                    Text("lbs")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            } else {
                Text("No data")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}


#Preview {
    BodySection(timeRange: .week)
        .padding()
        .previewWith(standard: TemplateApplicationStandard()) {
            HealthKit()
        }
}
