//
//  timercardview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 28/08/2025.
//

import SwiftUI

struct TimerCardView: View {
    @EnvironmentObject var timerManager: TimerManager
    @EnvironmentObject var blockerService: WebsiteBlockerService
    @State private var showingTimerSettings = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Timer Display
            VStack(spacing: 8) {
                Text(timerManager.displayTime)
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                
                Text(timerManager.isRunning ? "LOCKED IN" : "READY TO LOCK IN")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(timerManager.isRunning ? .red : .gray)
                    .tracking(2)
            }
            
            // Progress Ring
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                    .frame(width: 120, height: 120)
                
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
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: timerManager.progress)
            }
            
            // Control Buttons
            HStack(spacing: 16) {
                Button(action: { showingTimerSettings = true }) {
                    Image(systemName: "timer")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: toggleTimer) {
                    Text(timerManager.isRunning ? "STOP" : "START")
                        .font(.headline.weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(timerManager.isRunning ? Color.red : Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: { timerManager.reset() }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(timerManager.isRunning)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        )
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
