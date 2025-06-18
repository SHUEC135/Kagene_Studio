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
        ZStack {
            // 左端に戻るボタン
            HStack {
                Button {
                    viewModel.restart()
                } label: {
                    Image(systemName: "backward.end.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 64)
                        .foregroundColor(.primary)
                }
                Spacer()
            }

            // 中央に再生/一時停止ボタン
            Button {
                if viewModel.isPlaying {
                    viewModel.pause()
                } else {
                    viewModel.play()
                }
            } label: {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 96)
                    .foregroundColor(.primary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

//#Preview {
//    AudioPlayerView()
//}
