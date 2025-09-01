//
//  musicplayerservices.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 28/08/2025.
//

import SwiftUI
import AVFoundation
import Combine

class MusicPlayerService: ObservableObject {
    @Published var isPlaying = false
    @Published var currentTrack: Track?
    @Published var focusPlaylists: [Track] = []
    @Published var localTracks: [Track] = []
    @Published var recentTracks: [Track] = []
    
    private var audioPlayer: AVAudioPlayer?
    
    init() {
        setupDefaultTracks()
    }
    
    private func setupDefaultTracks() {
        // Focus playlists (simulated streaming)
        focusPlaylists = [
            Track(title: "Deep Focus", artist: "Focus Plug", duration: 3600, isStreamable: true),
            Track(title: "Lo-Fi Chill", artist: "Study Beats", duration: 2400, isStreamable: true),
            Track(title: "White Noise", artist: "Nature Sounds", duration: 1800, isStreamable: true),
            Track(title: "Brain Food", artist: "Productivity Mix", duration: 2700, isStreamable: true)
        ]
        
        // Recent tracks
        recentTracks = [
            Track(title: "Concentration", artist: "Mind Music", duration: 1500, isStreamable: true),
            Track(title: "Flow State", artist: "Focus Masters", duration: 2000, isStreamable: true)
        ]
        
        // Local tracks would be scanned from the user's Music library
        scanLocalMusic()
    }
    
    func selectTrack(_ track: Track) {
        currentTrack = track
        
        if isPlaying {
            stop()
        }
        
        play()
    }
    
    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func play() {
        guard let track = currentTrack else { return }
        
        if track.isStreamable {
            // Simulate streaming playback
            simulateStreamingPlayback()
        } else if let filePath = track.filePath {
            // Play local file
            playLocalFile(path: filePath)
        }
        
        isPlaying = true
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func stop() {
        audioPlayer?.stop()
        isPlaying = false
    }
    
    func nextTrack() {
        guard let current = currentTrack else { return }
        
        let allTracks = focusPlaylists + localTracks + recentTracks
        if let currentIndex = allTracks.firstIndex(where: { $0.id == current.id }),
           currentIndex < allTracks.count - 1 {
            selectTrack(allTracks[currentIndex + 1])
        }
    }
    
    func previousTrack() {
        guard let current = currentTrack else { return }
        
        let allTracks = focusPlaylists + localTracks + recentTracks
        if let currentIndex = allTracks.firstIndex(where: { $0.id == current.id }),
           currentIndex > 0 {
            selectTrack(allTracks[currentIndex - 1])
        }
    }
    
    private func simulateStreamingPlayback() {
        print("🎵 Now streaming: \(currentTrack?.title ?? "Unknown")")
        // In a real app, this would connect to streaming services or play URLs
    }
    
    private func playLocalFile(path: String) {
        do {
            let url = URL(fileURLWithPath: path)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing local file: \(error)")
        }
    }
    
    private func scanLocalMusic() {
        // In a real app, this would scan the user's Music library
        // Using FileManager to find audio files in common locations
        
        let musicPaths = [
            FileManager.default.urls(for: .musicDirectory, in: .userDomainMask),
            [URL(fileURLWithPath: NSHomeDirectory() + "/Music")]
        ].flatMap { $0 }
        
        for musicPath in musicPaths {
            scanDirectory(musicPath)
        }
    }
    
    private func scanDirectory(_ url: URL) {
        guard let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: nil) else { return }
        
        for case let fileURL as URL in enumerator {
            if ["mp3", "m4a", "wav", "aiff"].contains(fileURL.pathExtension.lowercased()) {
                let track = Track(
                    title: fileURL.deletingPathExtension().lastPathComponent,
                    artist: "Local Artist",
                    filePath: fileURL.path
                )
                localTracks.append(track)
            }
        }
    }
}
