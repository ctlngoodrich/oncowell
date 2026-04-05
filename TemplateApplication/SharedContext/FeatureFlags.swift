//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//


/// A collection of feature flags for OncoWell.
enum FeatureFlags {
    /// Skips the onboarding flow to enable easier development.
    static let skipOnboarding = CommandLine.arguments.contains("--skipOnboarding")
    /// Always show the onboarding when the application is launched.
    static let showOnboarding = CommandLine.arguments.contains("--showOnboarding")
}
