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
    
    func play() {
        player?.play()
        isPlaying = true
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
}
