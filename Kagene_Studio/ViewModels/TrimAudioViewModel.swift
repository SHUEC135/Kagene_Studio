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

        let asset = AVAsset(url: audioURL)
        let audioDuration = CMTimeGetSeconds(asset.duration) * 1000.0

        guard endMs <= audioDuration else {
            statusMessage = "End time exceeds audio length."
            return
        }

        let startTime = CMTime(milliseconds: startMs)
        let endTime = CMTime(milliseconds: endMs)

        AudioTrimmer.trimAudio(
            sourceURL: audioURL,
            startTime: startTime,
            endTime: endTime
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let outputURL):
                    self.statusMessage = "Trimmed and saved to:\n\(outputURL.lastPathComponent)"
                case .failure(let error):
                    self.statusMessage = "Error: \(error.localizedDescription)"
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
