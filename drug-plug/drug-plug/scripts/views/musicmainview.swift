//
//  musicmainview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 31/08/2025.
//
import SwiftUI

struct MusicMainView: View {
    @EnvironmentObject var musicPlayer: MusicPlayerService
    
    var body: some View {
        VStack(spacing: 32) {
            // Header
            Text("Focus Music")
                .font(.title2.weight(.bold))
                .foregroundColor(.black)
                .padding(.top, 24)
            
            // Compact Music Player
            CompactMusicPlayerView()
            
            // Music Categories
            VStack(alignment: .leading, spacing: 20) {
                Text("FOCUS PLAYLISTS")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.gray)
                    .tracking(1)
                    .padding(.horizontal, 32)
                
                LazyVStack(spacing: 8) {
                    ForEach(musicPlayer.focusPlaylists.prefix(4)) { track in
                        TrackCard(track: track)
                    }
                }
                .padding(.horizontal, 32)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct CompactMusicPlayerView: View {
    @EnvironmentObject var musicPlayer: MusicPlayerService
    
    var body: some View {
        VStack(spacing: 16) {
            // Album Art
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.red.opacity(0.8),
                            Color.orange.opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "music.note")
                        .font(.title2.weight(.light))
                        .foregroundColor(.white.opacity(0.8))
                )
                .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
            
            // Track Info
            VStack(spacing: 2) {
                Text(musicPlayer.currentTrack?.title ?? "No track selected")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Text(musicPlayer.currentTrack?.artist ?? "Select music to focus")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            // Controls
            HStack(spacing: 20) {
                Button(action: { musicPlayer.previousTrack() }) {
                    Image(systemName: "backward.fill")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: { musicPlayer.togglePlayPause() }) {
                    Image(systemName: musicPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .fill(
                                    Color.red
                                )
                                .frame(width: 44, height: 44)
                                .shadow(color: .red.opacity(0.3), radius: 6, x: 0, y: 3)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: { musicPlayer.nextTrack() }) {
                    Image(systemName: "forward.fill")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    Color.gray.opacity(0.05)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal, 32)
    }
}

struct TrackCard: View {
    let track: Track
    @EnvironmentObject var musicPlayer: MusicPlayerService
    
    var body: some View {
        Button(action: {
            musicPlayer.selectTrack(track)
        }) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "music.note")
                            .foregroundColor(.gray)
                            .font(.caption)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(track.title)
                        .foregroundColor(.black)
                        .font(.subheadline.weight(.medium))
                        .lineLimit(1)
                    Text(track.artist)
                        .foregroundColor(.gray)
                        .font(.caption)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Image(systemName: musicPlayer.currentTrack?.id == track.id ? "speaker.wave.2.fill" : "play.fill")
                    .foregroundColor(musicPlayer.currentTrack?.id == track.id ? .orange : .gray)
                    .font(.subheadline)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
