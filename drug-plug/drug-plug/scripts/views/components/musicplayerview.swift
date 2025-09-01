//
//  musicplayerview.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 28/08/2025.
//

import SwiftUI

struct MusicPlayerView: View {
    @EnvironmentObject var musicPlayer: MusicPlayerService
    @State private var showingMusicLibrary = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("FOCUS BEATS")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.gray)
                    .tracking(1)
                
                Spacer()
                
                Button("Library") {
                    showingMusicLibrary = true
                }
                .font(.caption)
                .foregroundColor(.orange)
            }
            
            HStack(spacing: 12) {
                // Album Art
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "music.note")
                            .foregroundColor(.gray)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(musicPlayer.currentTrack?.title ?? "No track selected")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(musicPlayer.currentTrack?.artist ?? "Select music to focus")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Controls
                Button(action: { musicPlayer.previousTrack() }) {
                    Image(systemName: "backward.fill")
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: { musicPlayer.togglePlayPause() }) {
                    Image(systemName: musicPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: { musicPlayer.nextTrack() }) {
                    Image(systemName: "forward.fill")
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .sheet(isPresented: $showingMusicLibrary) {
            MusicLibraryView()
        }
    }
}
