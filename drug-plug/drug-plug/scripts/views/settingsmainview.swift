//
//  settingsmainview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 31/08/2025.
//


import SwiftUI

struct SettingsMainView: View {
    @EnvironmentObject var blockerService: WebsiteBlockerService
    @State private var showingBlockList = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            Text("Settings")
                .font(.title2.weight(.bold))
                .foregroundColor(.black)
                .padding(.top, 32)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("WEBSITE BLOCKING")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.gray)
                    .tracking(1)
                    .padding(.horizontal, 32)
                
                VStack(spacing: 12) {
                    SettingsRow(
                        title: "Manage Block List",
                        subtitle: "\(blockerService.blockedWebsites.count) websites blocked",
                        icon: "shield.slash.fill",
                        color: .red
                    ) {
                        showingBlockList = true
                    }
                    
                    SettingsRow(
                        title: "Break Mode",
                        subtitle: "5 minute unblock periods",
                        icon: "cup.and.saucer.fill",
                        color: .green
                    ) {
                        blockerService.breakMode()
                    }
                }
                .padding(.horizontal, 32)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text("NOTIFICATIONS")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.gray)
                    .tracking(1)
                    .padding(.horizontal, 32)
                
                VStack(spacing: 12) {
                    SettingsToggleRow(
                        title: "Session Reminders",
                        subtitle: "Get notified when sessions end",
                        icon: "bell.fill",
                        color: .blue,
                        isOn: .constant(true)
                    )
                    
                    SettingsToggleRow(
                        title: "Break Reminders",
                        subtitle: "Gentle nudges to take breaks",
                        icon: "moon.fill",
                        color: .purple,
                        isOn: .constant(false)
                    )
                }
                .padding(.horizontal, 32)
            }
            
            Spacer()
        }
        .sheet(isPresented: $showingBlockList) {
            BlockListView()
        }
    }
}

struct SettingsRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline.weight(.medium))
                        .foregroundColor(.black)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsToggleRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline.weight(.medium))
                    .foregroundColor(.black)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: color))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        )
    }
}
