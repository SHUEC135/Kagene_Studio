//
//  RecordingView.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/05.
//

import SwiftUI

struct RecordingView: View {
    @StateObject private var recordingVM = RecordingViewModel()
    @StateObject private var recordPlayingVM = RecordPlayingViewModel()
    
    var body: some View {
        VStack(spacing: 24) {
            Text("録音音声")
                .font(.system(size: 24, weight: .bold))
            Text("長押ししながら録音")
                .font(.system(size: 24, weight: .bold))
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Capsule())
//            Button("Record") {
//                recordPlayingVM.loadAudio()
//                recordingVM.startRecording()
//            }
            Button {
                if recordPlayingVM.isPlaying {
                    recordPlayingVM.pause()
                } else {
                    recordPlayingVM.play()
                }
            } label: {
                Image(systemName: recordPlayingVM.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 96))
                    .foregroundColor(.primary)
            }
        }
    }
}

#Preview {
    RecordingView()
}
