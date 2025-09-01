//
//  FocusPlugApp.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 28/08/2025.
//


import SwiftUI
import UserNotifications

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
                .preferredColorScheme(.light)
                .onAppear {
                    setupApp()
                }
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 400, height: 650)
        
        MenuBarExtra("Focus Plug", systemImage: "brain.head.profile") {
            MenuBarView()
                .environmentObject(appState)
                .environmentObject(timerManager)
        }
    }
    
    private func setupApp() {
        requestNotificationPermission()
        timerManager.setupNotifications()
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
}
