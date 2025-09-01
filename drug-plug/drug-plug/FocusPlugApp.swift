//
//  statsmainview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 31/08/2025.
//



import SwiftUI

struct StatsMainView: View {
    @EnvironmentObject var statsManager: StatsManager
    
    var body: some View {
            
            // Today's Stats
            VStack(alignment: .leading, spacing: 20) {
                Text("TODAY'S DAMAGE")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.gray)
                    .tracking(1)
                    .padding(.horizontal, 32)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                    ModernStatCard(
                        title: "Sessions",
                        value: "\(statsManager.todaysSessions)",
                        color: .orange,
                        icon: "target"
                    )
                    
                    ModernStatCard(
                        title: "Focus Time",
                        value: statsManager.formattedTodaysTime,
                        color: .red,
                        icon: "clock.fill"
                    )
                    
                    ModernStatCard(
                        title: "Streak",
                        value: "\(statsManager.currentStreak)",
                        color: .green,
                        icon: "flame.fill"
                    )
                }
                .padding(.horizontal, 32)
            }
            
            // All Time Stats
            VStack(alignment: .leading, spacing: 20) {
                Text("ALL TIME STATS")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.gray)
                    .tracking(1)
                    .padding(.horizontal, 32)
                
                HStack(spacing: 16) {
                    ModernStatCard(
                        title: "Total Sessions",
                        value: "\(statsManager.totalSessions)",
                        color: .purple,
                        icon: "infinity"
                    )
                    
                    ModernStatCard(
                        title: "Total Time",
                        value: statsManager.formattedTotalTime,
                        color: .blue,
                        icon: "hourglass"
                    )
                }
                .padding(.horizontal, 32)
            }
            
            Spacer()
        }
    }
}

struct ModernStatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title.weight(.bold))
                    .foregroundColor(.black)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.gray.opacity(0.05),
                            Color.gray.opacity(0.02)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        )
    }
}
