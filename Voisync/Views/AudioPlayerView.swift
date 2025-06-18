//
//  ProjectView.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/05.
//

import SwiftUI


struct AudioPlayerView: View {
    @StateObject private var viewModel: AudioPlayerViewModel
    let filePath: String

    init(filePath: String) {
        self.filePath = filePath
        _viewModel = StateObject(wrappedValue: AudioPlayerViewModel(filePath: filePath))
    }

    var body: some View {
        HStack {
            
            Button("Return to Start") {
                viewModel.restart()
            }
            Button(viewModel.isPlaying ? "Pause" : "Play") {
                if viewModel.isPlaying {
                    viewModel.pause()
                } else {
                    viewModel.play()
                }
            }
        }
    }
}

//#Preview {
//    AudioPlayerView()
//}
