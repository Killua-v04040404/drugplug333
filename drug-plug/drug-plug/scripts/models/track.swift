//
//  track.swift
//  drug-plug
//
//  Created by Morris Romagnoli on 28/08/2025.
//

import Foundation

struct Track: Identifiable, Codable {
    let id = UUID()
    let title: String
    let artist: String
    let duration: TimeInterval
    let filePath: String?
    let isStreamable: Bool
    
    init(title: String, artist: String, duration: TimeInterval = 0, filePath: String? = nil, isStreamable: Bool = false) {
        self.title = title
        self.artist = artist
        self.duration = duration
        self.filePath = filePath
        self.isStreamable = isStreamable
    }
}
