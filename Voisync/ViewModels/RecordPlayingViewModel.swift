//
//  RecordPlayingViewModel.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/05.
//

import Foundation
import AVFoundation

class RecordPlayingViewModel: ObservableObject {
    @Published var isPlaying: Bool = false
    private var player: AVAudioPlayer?
    
    private func getAudioFileURL() -> URL {
        FileManager.default.temporaryDirectory.appendingPathComponent("recording.m4a")
    }

    func loadAudio() {
        let url = getAudioFileURL()
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.prepareToPlay()
            } catch {
                // handle error
            }
        }
    }

    func play() {
        player?.play()
        isPlaying = true
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }
}
