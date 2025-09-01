//
//  timermanager.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 28/08/2025.
//

import SwiftUI
import UserNotifications
import Combine

class TimerManager: ObservableObject {
    @Published var isRunning = false
    @Published var timeRemaining = 1500 // 25 minutes default
    @Published var duration = 1500
    @Published var progress: Double = 0
    @Published var displayTime = "25:00"
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        updateDisplayTime()
        setupBindings()
    }
    
    private func setupBindings() {
        $timeRemaining
            .sink { [weak self] _ in
                self?.updateDisplayTime()
                self?.updateProgress()
            }
            .store(in: &cancellables)
    }
    
    func start() {
        guard !isRunning else { return }
        
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
        
        sendNotification(title: "Focus Session Started", body: "Time to lock in! 🔥")
    }
    
    func stop() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        
        sendNotification(title: "Session Stopped", body: "Focus session ended early")
    }
    
    func reset() {
        stop()
        timeRemaining = duration
        updateDisplayTime()
        updateProgress()
    }
    
    func setDuration(_ seconds: Int) {
        duration = seconds
        timeRemaining = seconds
        updateDisplayTime()
        updateProgress()
    }
    
    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            // Timer finished
            complete()
        }
    }
    
    private func complete() {
        stop()
        sendNotification(title: "Focus Session Complete! 🎉", body: "Great job! Time for a break.")
        
        // Reset for next session
        timeRemaining = duration
    }
    
    private func updateDisplayTime() {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        displayTime = String(format: "%d:%02d", minutes, seconds)
    }
    
    private func updateProgress() {
        if duration > 0 {
            progress = Double(duration - timeRemaining) / Double(duration)
        } else {
            progress = 0
        }
    }
    
    func setupNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    
    private func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
