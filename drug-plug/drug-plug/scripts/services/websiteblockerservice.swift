//
//  websiteblockerservice.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 28/08/2025.
//

import SwiftUI
import Network
import Combine

class WebsiteBlockerService: ObservableObject {
    @Published var isBlocking = false
    @Published var blockedWebsites: [String] = [
        "twitter.com",
        "facebook.com",
        "instagram.com",
        "youtube.com",
        "reddit.com",
        "tiktok.com",
        "netflix.com"
    ]
    
    private let hostsFilePath = "/etc/hosts"
    private let backupHostsPath = "/tmp/hosts_backup"
    
    init() {
        loadBlockedWebsites()
    }
    
    func blockWebsites() {
        // In a real app, this would modify the hosts file or use a content filter
        // For demo purposes, we'll simulate blocking
        isBlocking = true
        
        print("🚫 Blocking websites:")
        blockedWebsites.forEach { website in
            print("- \(website)")
        }
        
        // Simulate hosts file modification
        simulateHostsModification(blocking: true)
    }
    
    func unblockAll() {
        isBlocking = false
        
        print("✅ Unblocking all websites")
        simulateHostsModification(blocking: false)
    }
    
    func breakMode() {
        unblockAll()
        
        // Re-enable blocking after 5 minutes
        DispatchQueue.main.asyncAfter(deadline: .now() + 300) { [weak self] in
            self?.blockWebsites()
        }
        
        print("☕ Break mode: 5 minutes of freedom")
    }
    
    func addWebsiteToBlockList(_ website: String) {
        let cleanWebsite = website.replacingOccurrences(of: "https://", with: "")
                                  .replacingOccurrences(of: "http://", with: "")
                                  .replacingOccurrences(of: "www.", with: "")
        
        if !blockedWebsites.contains(cleanWebsite) {
            blockedWebsites.append(cleanWebsite)
            saveBlockedWebsites()
        }
    }
    
    func removeWebsiteFromBlockList(_ website: String) {
        blockedWebsites.removeAll { $0 == website }
        saveBlockedWebsites()
    }
    
    private func simulateHostsModification(blocking: Bool) {
        // In a real implementation, this would require admin privileges
        // and modify the actual hosts file with entries like:
        // 127.0.0.1 twitter.com
        // 127.0.0.1 www.twitter.com
        
        if blocking {
            print("📝 Adding blocking entries to hosts file...")
        } else {
            print("📝 Removing blocking entries from hosts file...")
        }
    }
    
    private func loadBlockedWebsites() {
        if let data = UserDefaults.standard.data(forKey: "blockedWebsites"),
           let websites = try? JSONDecoder().decode([String].self, from: data) {
            blockedWebsites = websites
        }
    }
    
    private func saveBlockedWebsites() {
        if let data = try? JSONEncoder().encode(blockedWebsites) {
            UserDefaults.standard.set(data, forKey: "blockedWebsites")
        }
    }
}
