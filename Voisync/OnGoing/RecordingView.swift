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
    @State private var isPressing = false

    
    var body: some View {
        VStack(spacing: 24) {
            Text("録音音声")
                .font(.system(size: 24, weight: .bold))
            Text("長押ししながら録音")
                .font(.system(size: 24, weight: .bold))
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(isPressing ? Color.red.opacity(0.7) : Color.red)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .scaleEffect(isPressing ? 0.9 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isPressing)
                .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
                    isPressing = pressing
                    if pressing {
                        recordingVM.startRecording()
                    } else {
                        recordingVM.stopRecording()
                        recordPlayingVM.loadAudio()
                    }
                }, perform: {})
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
