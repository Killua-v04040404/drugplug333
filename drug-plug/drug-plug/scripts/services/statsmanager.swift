//
//  statsmanager.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 28/08/2025.
//

import SwiftUI
import Combine

class StatsManager: ObservableObject {
    @Published var currentStreak = 5
    @Published var todaysSessions = 3
    @Published var todaysFocusTime = 4500 // seconds
    @Published var totalSessions = 47
    @Published var totalFocusTime = 150300 // seconds
    
    var formattedTodaysTime: String {
        let hours = todaysFocusTime / 3600
        let minutes = (todaysFocusTime % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    var formattedTotalTime: String {
        let hours = totalFocusTime / 3600
        let minutes = (totalFocusTime % 3600) / 60
        
        return "\(hours)h \(minutes)m"
    }
    
    init() {
        loadStats()
    }
    
    func sessionCompleted(duration: Int) {
        todaysSessions += 1
        todaysFocusTime += duration
        totalSessions += 1
        totalFocusTime += duration
        
        updateStreak()
        saveStats()
    }
    
    func sessionSkipped() {
        // Handle skipped sessions - might break streak depending on rules
        saveStats()
    }
    
    private func updateStreak() {
        let lastSessionDate = UserDefaults.standard.object(forKey: "lastSessionDate") as? Date ?? Date()
        let today = Date()
        
        let calendar = Calendar.current
        let daysDifference = calendar.dateComponents([.day], from: lastSessionDate, to: today).day ?? 0
        
        if daysDifference <= 1 {
            // Maintain or increment streak
            if daysDifference == 1 {
                currentStreak += 1
            }
        } else {
            // Streak broken
            currentStreak = 1
        }
        
        UserDefaults.standard.set(today, forKey: "lastSessionDate")
    }
    
    private func loadStats() {
        currentStreak = UserDefaults.standard.integer(forKey: "currentStreak")
        if currentStreak == 0 { currentStreak = 1 }
        
        todaysSessions = UserDefaults.standard.integer(forKey: "todaysSessions")
        todaysFocusTime = UserDefaults.standard.integer(forKey: "todaysFocusTime")
        totalSessions = UserDefaults.standard.integer(forKey: "totalSessions")
        totalFocusTime = UserDefaults.standard.integer(forKey: "totalFocusTime")
        
        // Reset daily stats if it's a new day
        checkAndResetDailyStats()
    }
    
    private func saveStats() {
        UserDefaults.standard.set(currentStreak, forKey: "currentStreak")
        UserDefaults.standard.set(todaysSessions, forKey: "todaysSessions")
        UserDefaults.standard.set(todaysFocusTime, forKey: "todaysFocusTime")
        UserDefaults.standard.set(totalSessions, forKey: "totalSessions")
        UserDefaults.standard.set(totalFocusTime, forKey: "totalFocusTime")
        UserDefaults.standard.set(Date(), forKey: "lastSaveDate")
    }
    
    private func checkAndResetDailyStats() {
        let lastSaveDate = UserDefaults.standard.object(forKey: "lastSaveDate") as? Date ?? Date()
        let today = Date()
        
        let calendar = Calendar.current
        if !calendar.isDate(lastSaveDate, inSameDayAs: today) {
            // New day - reset daily stats
            todaysSessions = 0
            todaysFocusTime = 0
        }
    }
}
