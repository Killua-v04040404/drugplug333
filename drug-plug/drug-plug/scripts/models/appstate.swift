//
//  appstate.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 28/08/2025.
//
//
//  appstate.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 28/08/2025.
//
import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isSessionActive = false
    @Published var selectedTab: ViewType = .timer
    @Published var showingSettings = false
    
    enum ViewType {
        case timer, stats, settings, music
    }
    
    init() {
        // Initialize app state
    }
}
