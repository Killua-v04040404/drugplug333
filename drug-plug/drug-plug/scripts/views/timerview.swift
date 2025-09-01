//
//  timerview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 31/08/2025.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var timerManager: TimerManager
    @EnvironmentObject var blockerService: WebsiteBlockerService
    @State private var selectedCategory = "General"
    @State private var intention = ""
    @State private var showingCategoryPicker = false
    @State private var showingTimerSettings = false
    
    let categories = ["General", "Deep Work", "Study", "Creative", "Reading"]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 32) {
                    // Progress dots
                    HStack(spacing: 8) {
                        ForEach(0..<7, id: \.self) { index in
                            Circle()
                                .fill(index == 0 ? Color.red : Color.gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.top, 24)
                    
                    // Focus Question Section
                    VStack(spacing: 24) {
                        Text("What's your focus?")
                            .font(.title2.weight(.semibold))
                            .foregroundColor(.black)
                        
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
                                    .fill(Color.white)
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
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
                        TextField("What will you focus on?", text: $intention)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                            )
                            .frame(maxWidth: min(geometry.size.width - 64, 300))
                    }
                    
                    // Circular Timer
                    CircularTimerView()
                        .frame(width: min(geometry.size.width - 100, 280), height: min(geometry.size.width - 100, 280))
                    
                    // Time display
                    Text(timerManager.displayTime)
                        .font(.system(size: min(geometry.size.width / 12, 32), weight: .light, design: .monospaced))
                        .foregroundColor(.gray)
                    
                    // Session time range
                    if !timerManager.isRunning {
                        Text("21:14 → 09:46")
                            .font(.caption.weight(.medium))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.gray.opacity(0.1))
                            )
                    }
                    
                    // Start Session Button
                    Button(action: toggleTimer) {
                        Text(timerManager.isRunning ? "STOP SESSION" : "START SESSION")
                            .font(.headline.weight(.bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: min(geometry.size.width - 64, 250), minHeight: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.red)
                                    .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .scaleEffect(timerManager.isRunning ? 0.98 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: timerManager.isRunning)
                    
                    // Timer settings button
                    Button(action: { showingTimerSettings = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "timer")
                                .font(.subheadline)
                            Text("Timer Settings")
                                .font(.subheadline.weight(.medium))
                        }
                        .foregroundColor(.gray)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.1))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.bottom, 32)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showingTimerSettings) {
            TimerSettingsView()
        }
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

struct CircularTimerView: View {
    @EnvironmentObject var timerManager: TimerManager
    
    var body: some View {
        ZStack {
            // Tick marks around the circle
            ZStack {
                ForEach(0..<60, id: \.self) { tick in
                    Rectangle()
                        .fill(Color.gray.opacity(tick % 15 == 0 ? 0.8 : (tick % 5 == 0 ? 0.4 : 0.2)))
                        .frame(
                            width: tick % 15 == 0 ? 3 : (tick % 5 == 0 ? 2 : 1),
                            height: tick % 15 == 0 ? 20 : (tick % 5 == 0 ? 12 : 6)
                        )
                        .offset(y: -120)
                        .rotationEffect(.degrees(Double(tick) * 6))
                }
            }
            
            // Background circle
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                .frame(width: 240, height: 240)
            
            // Progress circle with gradient
            Circle()
                .trim(from: 0, to: timerManager.progress)
                .stroke(
                    LinearGradient(
                        colors: [.red, .orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 240, height: 240)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: timerManager.progress)
            
            // Progress indicator dot
            Circle()
                .fill(Color.red)
                .frame(width: 16, height: 16)
                .offset(y: -120)
                .rotationEffect(.degrees(-90 + (timerManager.progress * 360)))
                .shadow(color: .red.opacity(0.4), radius: 4, x: 0, y: 2)
                .animation(.easeInOut(duration: 1.0), value: timerManager.progress)
            
            // Center content
            VStack(spacing: 8) {
                Text(timerManager.isRunning ? "LOCKED IN" : "READY")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(timerManager.isRunning ? .red : .gray)
                    .tracking(2)
                    .animation(.easeInOut, value: timerManager.isRunning)
            }
        }
    }
}