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


struct ActivitySection: View {
    let timeRange: TimeRange

    // swiftlint:disable attributes
    @HealthKitStatisticsQuery(
        .stepCount,
        aggregatedBy: [.sum],
        over: .day,
        timeRange: .last(days: 7)
    )
    private var dailySteps

    @HealthKitStatisticsQuery(
        .appleExerciseTime,
        aggregatedBy: [.sum],
        over: .day,
        timeRange: .last(days: 7)
    )
    private var dailyExercise
    // swiftlint:enable attributes


    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Activity", systemImage: "figure.walk")
                .font(.headline)
                .foregroundStyle(.green)
            stepsCard
            exerciseCard
        }
    }

    private var stepsCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Steps")
                .font(.subheadline)
                .fontWeight(.semibold)
            todaySteps
            HealthChart {
                HealthChartEntry(
                    $dailySteps,
                    aggregationOption: .sum,
                    drawingConfig: .init(chartType: .bar, color: .green)
                )
            }
            .frame(height: 120)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }

    private var todaySteps: some View {
        Group {
            if let today = dailySteps.last,
               let sum = today.sumQuantity() {
                let steps = sum.doubleValue(for: .count())
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(Int(steps))")
                        .font(.title)
                        .fontWeight(.bold)
                        .monospacedDigit()
                    Text("steps today")
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

    private var exerciseCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Exercise")
                .font(.subheadline)
                .fontWeight(.semibold)
            todayExercise
            HealthChart {
                HealthChartEntry(
                    $dailyExercise,
                    aggregationOption: .sum,
                    drawingConfig: .init(chartType: .bar, color: .orange)
                )
            }
            .frame(height: 120)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }

    private var todayExercise: some View {
        Group {
            if let today = dailyExercise.last,
               let sum = today.sumQuantity() {
                let minutes = sum.doubleValue(for: .minute())
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(Int(minutes))")
                        .font(.title)
                        .fontWeight(.bold)
                        .monospacedDigit()
                    Text("min today")
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
    ActivitySection(timeRange: .week)
        .padding()
        .previewWith(standard: TemplateApplicationStandard()) {
            HealthKit()
        }
}
