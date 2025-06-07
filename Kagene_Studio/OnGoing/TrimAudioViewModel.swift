//
//  TrimAudioViewModel.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/07.
//

import Foundation
import AVFoundation
import SwiftUI

class TrimAudioViewModel: ObservableObject {
    @Published var firstThreeWords: String = ""
    @Published var startTimeMs: String = ""
    @Published var endTimeMs: String = ""
    @Published var statusMessage: String = ""

    private var originalAudioURL: URL?

    init() {
        if let url = Bundle.main.url(forResource: "sample", withExtension: "mp3") {
            self.originalAudioURL = url
        } else {
            self.statusMessage = "Failed to load audio file."
        }
    }

    func trimAudio() {
        guard let audioURL = originalAudioURL else {
            statusMessage = "Audio file not found."
            return
        }

        guard let startMs = Double(startTimeMs),
              let endMs = Double(endTimeMs),
              startMs >= 0,
              endMs > startMs else {
            statusMessage = "Invalid input times."
            return
        }

        let asset = AVURLAsset(url: audioURL)
        let audioDuration = CMTimeGetSeconds(asset.duration) * 1000.0

        guard endMs <= audioDuration else {
            statusMessage = "End time exceeds audio length."
            return
        }

        let startTime = CMTime(milliseconds: startMs)
        let endTime = CMTime(milliseconds: endMs)

        Task {
            do {
                let output = try await AudioTrimmer.trimAudio(sourceURL: audioURL, startTime: startTime, endTime: endTime)
                await MainActor.run {
                    self.statusMessage = "Saved: \(output.lastPathComponent)"
                }
            } catch {
                await MainActor.run {
                    self.statusMessage = "Failed: \(error.localizedDescription)"
                }
            }
        }
    }
}

extension CMTime {
    init(milliseconds: Double) {
        self.init(seconds: milliseconds / 1000.0, preferredTimescale: 600)
    }
}
