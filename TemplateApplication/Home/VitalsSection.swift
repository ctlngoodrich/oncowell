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


struct VitalsSection: View {
    let timeRange: TimeRange

    // swiftlint:disable attributes
    @HealthKitStatisticsQuery(
        .heartRate,
        aggregatedBy: [.average, .min, .max],
        over: .day,
        timeRange: .last(days: 7)
    )
    private var heartRateStats

    @HealthKitQuery(.heartRate, timeRange: .last(days: 7))
    private var heartRateSamples
    // swiftlint:enable attributes


    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Vitals", systemImage: "heart.fill")
                .font(.headline)
                .foregroundStyle(.red)
            heartRateCard
        }
    }

    private var heartRateCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Heart Rate")
                .font(.subheadline)
                .fontWeight(.semibold)
            latestHeartRate
            HealthChart {
                HealthChartEntry(
                    $heartRateSamples,
                    drawingConfig: .init(chartType: .line, color: .red)
                )
            }
            .frame(height: 150)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }

    private var latestHeartRate: some View {
        Group {
            if let latest = heartRateSamples.last {
                let bpm = latest.quantity.doubleValue(
                    for: HKUnit.count().unitDivided(by: .minute())
                )
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(Int(bpm))")
                        .font(.title)
                        .fontWeight(.bold)
                        .monospacedDigit()
                    Text("bpm")
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
    VitalsSection(timeRange: .week)
        .padding()
        .previewWith(standard: TemplateApplicationStandard()) {
            HealthKit()
        }
}
