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
        VStack {
            Text("Hold to Record")
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            if !recordingVM.isRecording {
                                recordingVM.startRecording()
                            }
                        }
                        .onEnded { _ in
                            recordingVM.stopRecording()
                            recordPlayingVM.loadAudio()
                        }
                )
//            Button("Record") {
//                recordPlayingVM.loadAudio()
//                recordingVM.startRecording()
//            }
            Button(recordPlayingVM.isPlaying ? "Pause" : "Play") {
                if recordPlayingVM.isPlaying {
                    recordPlayingVM.pause()
                } else {
                    recordPlayingVM.play()
                }
            }
        }
    }
}

#Preview {
    RecordingView()
}
