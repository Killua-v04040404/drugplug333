//
//  sidebarview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 31/08/2025.
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 24) {
            // Logo/Icon at top
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [.red, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "brain.head.profile")
                            .font(.title2.weight(.bold))
                            .foregroundColor(.white)
                    )
                    .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.top, 24)
            
            // Navigation Items
            VStack(spacing: 16) {
                SidebarItem(
                    icon: "timer",
                    label: "Timer",
                    isSelected: appState.selectedTab == .timer
                ) {
                    appState.selectedTab = .timer
                }
                
                SidebarItem(
                    icon: "chart.bar.fill",
                    label: "Stats",
                    isSelected: appState.selectedTab == .stats
                ) {
                    appState.selectedTab = .stats
                }
                
                SidebarItem(
                    icon: "music.note",
                    label: "Music",
                    isSelected: appState.selectedTab == .music
                ) {
                    appState.selectedTab = .music
                }
                
                SidebarItem(
                    icon: "star.fill",
                    label: "Focus",
                    isSelected: false
                ) {
                    // Additional focus features
                }
            }
            
            Spacer()
            
            // Settings at bottom
            SidebarItem(
                icon: "gearshape.fill",
                label: "Settings",
                isSelected: appState.selectedTab == .settings
            ) {
                appState.selectedTab = .settings
            }
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity)
    }
}

struct SidebarItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title2.weight(isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? .white : .gray)
                    .frame(width: 24, height: 24)
                
                Text(label)
                    .font(.caption2.weight(.medium))
                    .foregroundColor(isSelected ? .white : .gray)
            }
            .frame(width: 60, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isSelected ?
                        LinearGradient(
                            colors: [.red.opacity(0.8), .orange.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [
                                isHovered ? Color.white.opacity(0.1) : Color.clear,
                                isHovered ? Color.white.opacity(0.05) : Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(
                        color: isSelected ? .red.opacity(0.3) : .clear,
                        radius: isSelected ? 8 : 0,
                        x: 0,
                        y: isSelected ? 4 : 0
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}
