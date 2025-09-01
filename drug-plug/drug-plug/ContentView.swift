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
        VStack(spacing: 0) {
            // Main Content Area
            VStack(spacing: 0) {
                // Content based on selected view
                switch appState.selectedTab {
                case .timer:
                    CompactTimerView()
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
            
            // Bottom Navigation
            BottomNavigationView()
        }
        .frame(width: 400, height: 600)
        .background(Color.white)
    }
}

struct CompactTimerView: View {
    @EnvironmentObject var timerManager: TimerManager
    @EnvironmentObject var blockerService: WebsiteBlockerService
    @State private var selectedCategory = "General"
    @State private var intention = ""
    @State private var showingCategoryPicker = false
    
    let categories = ["General", "Deep Work", "Study", "Creative", "Reading"]
    
    var body: some View {
        VStack(spacing: 24) {
            // Top section with window controls simulation and progress dots
            HStack {
                HStack(spacing: 8) {
                    Circle().fill(Color.red).frame(width: 12, height: 12)
                    Circle().fill(Color.orange).frame(width: 12, height: 12)
                    Circle().fill(Color.green).frame(width: 12, height: 12)
                }
                
                Spacer()
                
                // Progress dots
                HStack(spacing: 8) {
                    ForEach(0..<7, id: \.self) { index in
                        Circle()
                            .fill(index == 0 ? Color.gray.opacity(0.8) : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                
                Spacer()
                
                // Break mode button
                Button(action: { blockerService.breakMode() }) {
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .frame(width: 32, height: 32)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.1))
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            // Focus question
            Text("What's your focus?")
                .font(.title2.weight(.medium))
                .foregroundColor(.black)
                .padding(.top, 8)
            
            // Category selector
            Button(action: { showingCategoryPicker = true }) {
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                    
                    Text(selectedCategory)
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.black)
                    
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(Color.gray.opacity(0.1))
                        .overlay(
                            Capsule()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            .popover(isPresented: $showingCategoryPicker) {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(categories, id: \.self) { category in
                        Button(category) {
                            selectedCategory = category
                            showingCategoryPicker = false
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                }
                .padding(8)
                .background(Color.white)
            }
            
            // Intention input
            TextField("Intention", text: $intention)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.subheadline)
                .foregroundColor(.black)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 32)
            
            // Analog Timer Dial
            AnalogTimerDialView()
            
            // Time display
            Text(timerManager.displayTime)
                .font(.system(size: 32, weight: .light, design: .monospaced))
                .foregroundColor(.gray)
            
            // Session time range
            Text("20.25 → 08.14")
                .font(.caption.weight(.medium))
                .foregroundColor(.gray)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.gray.opacity(0.1))
                )
            
            // Start Session Button
            Button(action: toggleTimer) {
                Text(timerManager.isRunning ? "STOP SESSION" : "START SESSION")
                    .font(.headline.weight(.bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.red)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 32)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
    
    private func toggleTimer() {
        if timerManager.isRunning {
            timerManager.stop()
            blockerService.unblockAll()
        } else {
            timerManager.start()
            blockerService.blockWebsites()
        }
    }
}

struct AnalogTimerDialView: View {
    @EnvironmentObject var timerManager: TimerManager
    
    var body: some View {
        ZStack {
            // Outer tick marks
            ZStack {
                ForEach(0..<60, id: \.self) { tick in
                    Rectangle()
                        .fill(Color.gray.opacity(tick % 15 == 0 ? 0.6 : (tick % 5 == 0 ? 0.4 : 0.2)))
                        .frame(
                            width: tick % 15 == 0 ? 2 : 1,
                            height: tick % 15 == 0 ? 16 : (tick % 5 == 0 ? 12 : 8)
                        )
                        .offset(y: -100)
                        .rotationEffect(.degrees(Double(tick) * 6))
                }
            }
            
            // Main dial circle
            Circle()
                .fill(Color.red)
                .frame(width: 160, height: 160)
                .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
            
            // Timer hand
            Rectangle()
                .fill(Color.red.opacity(0.8))
                .frame(width: 4, height: 60)
                .offset(y: -30)
                .rotationEffect(.degrees(-90 + (timerManager.progress * 360)))
                .animation(.easeInOut(duration: 1.0), value: timerManager.progress)
            
            // Center dot
            Circle()
                .fill(Color.white)
                .frame(width: 16, height: 16)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
        }
        .frame(width: 200, height: 200)
    }
}

struct BottomNavigationView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack(spacing: 0) {
            BottomNavItem(
                icon: "timer",
                isSelected: appState.selectedTab == .timer,
                hasIndicator: appState.selectedTab == .timer
            ) {
                appState.selectedTab = .timer
            }
            
            BottomNavItem(
                icon: "calendar",
                isSelected: appState.selectedTab == .stats
            ) {
                appState.selectedTab = .stats
            }
            
            BottomNavItem(
                icon: "chart.bar.fill",
                isSelected: false
            ) {
                // Additional stats view
            }
            
            BottomNavItem(
                icon: "person.fill",
                isSelected: false
            ) {
                // Profile view
            }
            
            BottomNavItem(
                icon: "star.fill",
                isSelected: false
            ) {
                // Favorites view
            }
            
            BottomNavItem(
                icon: "gearshape.fill",
                isSelected: appState.selectedTab == .settings
            ) {
                appState.selectedTab = .settings
            }
        }
        .padding(.vertical, 12)
        .background(Color.white)
        .overlay(
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1),
            alignment: .top
        )
    }
}

struct BottomNavItem: View {
    let icon: String
    let isSelected: Bool
    let hasIndicator: Bool
    let action: () -> Void
    
    init(icon: String, isSelected: Bool, hasIndicator: Bool = false, action: @escaping () -> Void) {
        self.icon = icon
        self.isSelected = isSelected
        self.hasIndicator = hasIndicator
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(isSelected ? .black : .gray)
                    
                    if hasIndicator {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 6, height: 6)
                            .offset(x: 12, y: -12)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
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
