//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


// swiftlint:disable:next file_types_order
struct SymptomRow: View {
    let entry: SymptomLogEntry

    var body: some View {
        HStack(spacing: 12) {
            icon
            content
            Spacer()
            severityBadge
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }

    private var icon: some View {
        Image(systemName: "heart.text.square")
            .font(.title3)
            .foregroundStyle(.red)
            .frame(width: 36, height: 36)
            .background(Color.red.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .accessibilityHidden(true)
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.symptomType.rawValue)
                .font(.headline)
            Text(entry.date, style: .date)
                .font(.caption)
                .foregroundStyle(.secondary)
            if !entry.bodyLocation.isEmpty {
                Text(entry.bodyLocation)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var severityBadge: some View {
        Text(entry.severity.label)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(severityColor.opacity(0.15))
            .foregroundStyle(severityColor)
            .clipShape(Capsule())
    }

    private var severityColor: Color {
        switch entry.severity {
        case .mild: .green
        case .moderate: .orange
        case .severe: .red
        }
    }
}


struct TestResultRow: View {
    let result: TestResult

    var body: some View {
        HStack(spacing: 12) {
            icon
            content
            Spacer()
            valueLabel
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }

    private var icon: some View {
        Image(systemName: "flask.fill")
            .font(.title3)
            .foregroundStyle(.blue)
            .frame(width: 36, height: 36)
            .background(Color.blue.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .accessibilityHidden(true)
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(result.testName)
                .font(.headline)
            Text(result.date, style: .date)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var valueLabel: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text(result.value)
                .font(.headline)
                .monospacedDigit()
            if !result.unit.isEmpty {
                Text(result.unit)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}


struct VisitNoteRow: View {
    let note: DoctorVisitNote

    var body: some View {
        HStack(spacing: 12) {
            icon
            content
            Spacer()
            typeBadge
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }

    private var icon: some View {
        Image(systemName: "note.text")
            .font(.title3)
            .foregroundStyle(.green)
            .frame(width: 36, height: 36)
            .background(Color.green.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .accessibilityHidden(true)
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(note.providerName.isEmpty ? "Visit Note" : note.providerName)
                .font(.headline)
            Text(note.date, style: .date)
                .font(.caption)
                .foregroundStyle(.secondary)
            if !note.facilityName.isEmpty {
                Text(note.facilityName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var typeBadge: some View {
        Text(note.visitType.rawValue)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.green.opacity(0.15))
            .foregroundStyle(.green)
            .clipShape(Capsule())
    }
}


#Preview("Symptom") {
    SymptomRow(entry: SymptomLogEntry(
        symptomType: .pain,
        severity: .moderate,
        bodyLocation: "Lower back"
    ))
    .padding()
}


#Preview("Test Result") {
    TestResultRow(result: TestResult(
        testType: .psa,
        testName: "PSA",
        value: "4.2",
        unit: "ng/mL"
    ))
    .padding()
}
