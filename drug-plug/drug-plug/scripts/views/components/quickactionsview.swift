//
//  quickactionsview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 28/08/2025.
//
import SwiftUI

struct QuickActionsView: View {
    @EnvironmentObject var blockerService: WebsiteBlockerService
    @State private var showingBlockList = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("QUICK ACTIONS")
                .font(.caption.weight(.bold))
                .foregroundColor(.gray)
                .tracking(1)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                ModernActionButton(
                    title: "Block Sites",
                    subtitle: "Lock down distractions",
                    icon: "shield.slash.fill",
                    color: .red,
                    isActive: blockerService.isBlocking
                ) {
                    if blockerService.isBlocking {
                        blockerService.unblockAll()
                    } else {
                        blockerService.blockWebsites()
                    }
                }
                
                ModernActionButton(
                    title: "Break Mode",
                    subtitle: "5 min freedom",
                    icon: "cup.and.saucer.fill",
                    color: .green
                ) {
                    blockerService.breakMode()
                }
            }
        }
        .sheet(isPresented: $showingBlockList) {
            BlockListView()
        }
    }
}

struct ModernActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let isActive: Bool
    let action: () -> Void
    
    @State private var isHovered = false
    
    init(title: String, subtitle: String, icon: String, color: Color, isActive: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
        self.isActive = isActive
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: icon)
                        .font(.title2.weight(.medium))
                        .foregroundColor(isActive ? .white : color)
                    Spacer()
                    
                    if isActive {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline.weight(.semibold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding(20)
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isActive ?
                        LinearGradient(
                            colors: [color.opacity(0.8), color.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [
                                Color.white.opacity(isHovered ? 0.08 : 0.05),
                                Color.white.opacity(isHovered ? 0.05 : 0.02)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isActive ? color.opacity(0.5) : color.opacity(0.2),
                                lineWidth: 1
                            )
                    )
                    .shadow(
                        color: isActive ? color.opacity(0.3) : .black.opacity(0.1),
                        radius: isActive ? 12 : 8,
                        x: 0,
                        y: isActive ? 6 : 4
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
    }
}
