//
//  ContentView.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 28/08/2025.


import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var timerManager: TimerManager
    @EnvironmentObject var blockerService: WebsiteBlockerService
    @EnvironmentObject var musicPlayer: MusicPlayerService
    @EnvironmentObject var statsManager: StatsManager
    
    var body: some View {
        HStack(spacing: 0) {
            // Persistent Sidebar
            SidebarView()
                .frame(width: 80)
                .background(
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.08, green: 0.08, blue: 0.12),
                                    Color(red: 0.05, green: 0.05, blue: 0.08)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                )
            
            // Main Content Area
            VStack(spacing: 0) {
                // Content based on selected view
                switch appState.selectedTab {
                case .timer:
                    TimerView()
                case .stats:
                    StatsMainView()
                case .music:
                    MusicMainView()
                case .settings:
                    SettingsMainView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
        }
        .background(Color.white)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
        .environmentObject(TimerManager())
        .environmentObject(WebsiteBlockerService())
        .environmentObject(MusicPlayerService())
        .environmentObject(StatsManager())
}