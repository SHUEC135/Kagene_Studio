//
//  ContentView.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/04.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false

    var body: some View {
        VStack {
            Button(isPlaying ? "Pause" : "Play") {
                if let player = audioPlayer {
                    if player.isPlaying {
                        player.pause()
                        isPlaying = false
                    } else {
                        player.play()
                        isPlaying = true
                    }
                }
            }
        }
        .onAppear {
            if let url = Bundle.main.url(forResource: "sample", withExtension: "mp3") {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.prepareToPlay()
                } catch {
                    print("Error loading audio: \(error)")
                }
            }
        }
    }
}


