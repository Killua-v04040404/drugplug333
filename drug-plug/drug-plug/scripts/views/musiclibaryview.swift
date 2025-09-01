//
//  musiclibaryview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 28/08/2025.
//

import SwiftUI

struct MusicLibraryView: View {
    @EnvironmentObject var musicPlayer: MusicPlayerService
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Text("Music Library")
                    .font(.title2.weight(.bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button("Done") {
                    dismiss()
                }
                .font(.headline.weight(.medium))
                .foregroundColor(.orange)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.orange.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                        )
                )
                .buttonStyle(PlainButtonStyle())
            }
            
            // Music categories
            ScrollView {
                LazyVStack(spacing: 24) {
                    ModernCategorySection(title: "Focus Playlists", tracks: musicPlayer.focusPlaylists)
                    ModernCategorySection(title: "Local Music", tracks: musicPlayer.localTracks)
                    ModernCategorySection(title: "Recently Played", tracks: musicPlayer.recentTracks)
                }
            }
            
            Spacer()
        }
        .padding(32)
        .frame(width: 600, height: 700)
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
    }
}

struct ModernCategorySection: View {
    let title: String
    let tracks: [Track]
    @EnvironmentObject var musicPlayer: MusicPlayerService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline.weight(.semibold))
                .foregroundColor(.white)
            
            LazyVStack(spacing: 8) {
                ForEach(tracks) { track in
                    Button(action: {
                        musicPlayer.selectTrack(track)
                    }) {
                        HStack(spacing: 16) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.purple.opacity(0.6),
                                            Color.blue.opacity(0.4)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Image(systemName: "music.note")
                                        .foregroundColor(.white.opacity(0.8))
                                        .font(.subheadline)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(track.title)
                                    .foregroundColor(.white)
                                    .font(.subheadline.weight(.medium))
                                    .lineLimit(1)
                                Text(track.artist)
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            Image(systemName: musicPlayer.currentTrack?.id == track.id ? "speaker.wave.2.fill" : "play.circle.fill")
                                .foregroundColor(musicPlayer.currentTrack?.id == track.id ? .orange : .gray)
                                .font(.title2)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(musicPlayer.currentTrack?.id == track.id ? 0.08 : 0.03))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            musicPlayer.currentTrack?.id == track.id ? Color.orange.opacity(0.3) : Color.white.opacity(0.1),
                                            lineWidth: 1
                                        )
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}
