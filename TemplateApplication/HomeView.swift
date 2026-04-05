//
// This source file is part of the OncoWell application.
//
// SPDX-FileCopyrightText: 2026 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct HomeView: View {
    enum Tabs: String {
        case home
        case learn
        case track
        case appointments
    }


    @AppStorage(StorageKeys.homeTabSelection) private var selectedTab = Tabs.home
    @State private var showingSettings = false


    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: .home) {
                wrappedTab { HomeTab() }
            }
            Tab("Learn", systemImage: "book.fill", value: .learn) {
                wrappedTab { LearnTab() }
            }
            Tab("Track", systemImage: "chart.line.uptrend.xyaxis", value: .track) {
                wrappedTab { TrackTab() }
            }
            Tab("Appointments", systemImage: "calendar", value: .appointments) {
                wrappedTab { AppointmentsTab() }
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }

    private func wrappedTab<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationStack {
            content()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingSettings = true
                        } label: {
                            Image(systemName: "gearshape")
                                .accessibilityLabel("Settings")
                        }
                    }
                }
        }
    }
}


#Preview {
    HomeView()
        .previewWith(standard: TemplateApplicationStandard()) {
        }
}
