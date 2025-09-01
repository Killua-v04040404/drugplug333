//
//  timersettingsview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 28/08/2025.
//

import SwiftUI

struct TimerSettingsView: View {
    @EnvironmentObject var timerManager: TimerManager
    @Environment(\.dismiss) var dismiss
    @State private var selectedMinutes = 25
    @State private var selectedSeconds = 0
    
    let minutes = Array(1...120)
    let seconds = Array(0...59).filter { $0 % 5 == 0 }
    
    var body: some View {
        VStack(spacing: 32) {
            // Header
            HStack {
                Text("Timer Settings")
                    .font(.title2.weight(.bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.1))
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Duration Picker
            VStack(spacing: 24) {
                Text("Set Focus Duration")
                    .font(.headline.weight(.medium))
                    .foregroundColor(.white)
                
                HStack(spacing: 32) {
                    VStack(spacing: 12) {
                        Text("Minutes")
                            .font(.caption.weight(.medium))
                            .foregroundColor(.gray)
                        
                        Picker("Minutes", selection: $selectedMinutes) {
                            ForEach(minutes, id: \.self) { minute in
                                Text("\(minute)")
                                    .foregroundColor(.white)
                                    .tag(minute)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 100, height: 120)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.05))
                        )
                    }
                    
                    VStack(spacing: 12) {
                        Text("Seconds")
                            .font(.caption.weight(.medium))
                            .foregroundColor(.gray)
                        
                        Picker("Seconds", selection: $selectedSeconds) {
                            ForEach(seconds, id: \.self) { second in
                                Text(String(format: "%02d", second))
                                    .foregroundColor(.white)
                                    .tag(second)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 100, height: 120)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.05))
                        )
                    }
                }
            }
            
            // Quick presets
            VStack(alignment: .leading, spacing: 16) {
                Text("Quick Presets")
                    .font(.headline.weight(.medium))
                    .foregroundColor(.white)
                
                HStack(spacing: 12) {
                    ForEach([15, 25, 45, 60], id: \.self) { preset in
                        Button("\(preset)m") {
                            selectedMinutes = preset
                            selectedSeconds = 0
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    selectedMinutes == preset ?
                                    LinearGradient(
                                        colors: [.orange, .red],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ) :
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(
                                            selectedMinutes == preset ? Color.orange.opacity(0.5) : Color.white.opacity(0.2),
                                            lineWidth: 1
                                        )
                                )
                                .shadow(
                                    color: selectedMinutes == preset ? .orange.opacity(0.3) : .clear,
                                    radius: selectedMinutes == preset ? 8 : 0,
                                    x: 0,
                                    y: selectedMinutes == preset ? 4 : 0
                                )
                        )
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            Spacer()
            
            // Action Buttons
            HStack(spacing: 16) {
                Button("Cancel") {
                    dismiss()
                }
                .font(.headline.weight(.medium))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
                .buttonStyle(PlainButtonStyle())
                
                Button("Set Timer") {
                    let totalSeconds = (selectedMinutes * 60) + selectedSeconds
                    timerManager.setDuration(totalSeconds)
                    dismiss()
                }
                .font(.headline.weight(.bold))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [.orange, .red],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .orange.opacity(0.4), radius: 12, x: 0, y: 6)
                )
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(32)
        .frame(width: 400, height: 600)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.08, green: 0.08, blue: 0.12),
                            Color(red: 0.05, green: 0.05, blue: 0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        )
        .onAppear {
            selectedMinutes = timerManager.duration / 60
            selectedSeconds = timerManager.duration % 60
        }
    }
}
