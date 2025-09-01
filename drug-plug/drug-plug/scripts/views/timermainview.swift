//
//  timermainview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 31/08/2025.
//
import SwiftUI

struct TimerMainView: View {
    @EnvironmentObject var timerManager: TimerManager
    @EnvironmentObject var blockerService: WebsiteBlockerService
    @State private var showingTimerSettings = false
    
    var body: some View {
        VStack(spacing: 32) {
            // Top navigation dots
            HStack(spacing: 8) {
                ForEach(0..<7, id: \.self) { index in
                    Circle()
                        .fill(index == 0 ? Color.red : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.top, 20)
            
            // Focus Question Section
            VStack(spacing: 24) {
                Text("What's your focus?")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.black)
                
                HStack {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.red)
                        .font(.caption)
                    
                    Text("General")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.black)
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                )
                
                // Intention input
                TextField("What will you focus on?", text: .constant(""))
                    .textFieldStyle(PlainTextFieldStyle())
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
                    .foregroundColor(.black)
                    .font(.subheadline)
            }
            
            // Circular Timer
            CircularTimerView()
            
            // Start Session Button
            VStack(spacing: 16) {
                Button(action: toggleTimer) {
                    Text(timerManager.isRunning ? "STOP SESSION" : "START SESSION")
                        .font(.headline.weight(.bold))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.red)
                                .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .scaleEffect(timerManager.isRunning ? 0.98 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: timerManager.isRunning)
            }
            
            Spacer()
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
    @State private var pulseAnimation = false
    
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
                    Color.red,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 240, height: 240)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: timerManager.progress)
            
            // Progress indicator dot
            Circle()
                .fill(
                    Color.red
                )
                .frame(width: 16, height: 16)
                .offset(y: -120)
                .rotationEffect(.degrees(-90 + (timerManager.progress * 360)))
                .shadow(color: .red.opacity(0.4), radius: 4, x: 0, y: 2)
                .animation(.easeInOut(duration: 1.0), value: timerManager.progress)
            
            // Center content
            VStack(spacing: 12) {
                Text(timerManager.displayTime)
                    .font(.system(size: 40, weight: .thin, design: .monospaced))
                    .foregroundColor(.black)
                
                Text(timerManager.isRunning ? "LOCKED IN" : "READY TO LOCK IN")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.gray)
                    .tracking(2)
                    .animation(.easeInOut, value: timerManager.isRunning)
                
                // Session time range
                if !timerManager.isRunning {
                    Text("21:14 → 09:46")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.gray.opacity(0.15))
                        )
                        .padding(.top, 8)
                }
            }
        }
        .frame(width: 280, height: 280)
    }
}
