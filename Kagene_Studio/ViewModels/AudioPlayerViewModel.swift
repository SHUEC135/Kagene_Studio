//
//  ContentView.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/04.
//

import SwiftUI
import AVFoundation

class AudioPlayerViewModel: ObservableObject {
    @Published var isPlaying: Bool = false
    @Published var currentTime: TimeInterval = 0.00
    let filePath: String
    
    private var player: AVAudioPlayer?
    
    init(filePath: String) {
        self.filePath = filePath
        let url = URL(fileURLWithPath: filePath)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
        } catch {
            print("Error loading audio: \(error)")
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
    func restart() {
        guard let player = player else { return }
        player.currentTime = 0.0
        player.play()
        isPlaying = true
        currentTime = 0.0
    }
}









//struct ContentView: View {
//    @State private var audioPlayer: AVAudioPlayer?
//    @State private var isPlaying = false
//
//    var body: some View {
//        VStack {
//            Button(isPlaying ? "Pause" : "Play") {
//                if let player = audioPlayer {
//                    if player.isPlaying {
//                        player.pause()
//                        isPlaying = false
//                    } else {
//                        player.play()
//                        isPlaying = true
//                    }
//                }
//            }
//        }
//        .onAppear {
//            if let url = Bundle.main.url(forResource: "sample", withExtension: "mp3") {
//                do {
//                    audioPlayer = try AVAudioPlayer(contentsOf: url)
//                    audioPlayer?.prepareToPlay()
//                } catch {
//                    print("Error loading audio: \(error)")
//                }
//            }
//        }
//    }
//}


