//
//  statspreviewview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 28/08/2025.
//

import SwiftUI

struct StatsPreviewView: View {
    @EnvironmentObject var statsManager: StatsManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("TODAY'S DAMAGE")
                .font(.caption.weight(.bold))
                .foregroundColor(.gray)
                .tracking(1)
            
            HStack(spacing: 16) {
                StatItem(
                    title: "Sessions",
                    value: "\(statsManager.todaysSessions)",
                    color: .orange
                )
                
                StatItem(
                    title: "Focus Time",
                    value: statsManager.formattedTodaysTime,
                    color: .red
                )
                
                StatItem(
                    title: "Streak",
                    value: "\(statsManager.currentStreak)",
                    color: .green
                )
            }
        }
    }
}

struct StatItem: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title2.weight(.bold))
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.1))
        )
    }
}
