//
//  FocusPlugApp.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 28/08/2025.
//

import SwiftUI

@main
struct FocusPlugApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var timerManager = TimerManager()
    @StateObject private var blockerService = WebsiteBlockerService()
    @StateObject private var musicPlayer = MusicPlayerService()
    @StateObject private var statsManager = StatsManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(timerManager)
                .environmentObject(blockerService)
                .environmentObject(musicPlayer)
                .environmentObject(statsManager)
                .onAppear {
                    timerManager.setupNotifications()
                }
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 600, height: 700, depth: .zero)
        
        MenuBarExtra("Focus Plug", systemImage: "brain.head.profile") {
            MenuBarView()
                .environmentObject(appState)
                .environmentObject(timerManager)
                .environmentObject(blockerService)
                .environmentObject(musicPlayer)
                .environmentObject(statsManager)
        }
    }
}