//
//  AudioTrimFlowView.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/07.
//

import SwiftUI

struct AudioTrimFlowView: View {
    let filePath: String
    @StateObject private var viewModel: AudioTrimViewModel
    @StateObject private var waveformVM: WaveformScrollSliderViewModel
    @State private var currentStep: Step = .inputWords
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var projectListViewModel: ProjectListViewModel

    init(filePath: String) {
        self.filePath = filePath
        _viewModel = StateObject(wrappedValue: AudioTrimViewModel(filePath: filePath))
        _waveformVM = StateObject(
            wrappedValue: WaveformScrollSliderViewModel(filePath: filePath)
        )
    }

    enum Step {
        case inputWords
        case start
        case end
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                switch currentStep {
                case .inputWords:
                    VStack(spacing: 10) {
                        Text("最初の3単語を入力")
                            .font(.title2.weight(.semibold))
                            .foregroundColor(.primary)
                        TextField("例: When I was", text: $viewModel.firstThreeWords)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                case .start:
                    VStack {
                        Text("開始地点を選択")
                            .font(.title2.weight(.semibold))
                            .foregroundColor(.primary)
                        Text("タイマーの時間が開始地点です")
                            .font(.title3.weight(.regular))
                        WaveformScrollSliderView(filePath: filePath, vm: waveformVM)
                    }

                case .end:
                    VStack {
                        Text("終了地点を選択")
                            .font(.title2.weight(.semibold))
                            .foregroundColor(.primary)
                        Text("タイマーの時間が終了地点です")
                            .font(.title3.weight(.regular))
                        WaveformScrollSliderView(filePath: filePath, vm: waveformVM)
                    }
                }

                Text(viewModel.statusMessage)
                    .foregroundColor(.gray)
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if currentStep != .inputWords {
                        Button("戻る") {
                            moveBackward()
                        }
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    if currentStep == .end {
                        Button("完了") {
                            let endMs = waveformVM.selectedTimeMs
                            if endMs >= 0,
                               let startMsInt = Int(viewModel.startTimeMs),
                               endMs > startMsInt {
                                viewModel.endTimeMs = String(endMs)
                                print("✂️Trimming ends from \(String(viewModel.endTimeMs))ms")
                                viewModel.trimAudio()
                                dismiss()
                            } else {
                                viewModel.statusMessage = "開始時間より大きい値を指定してください"
                            }
                        }
                    } else {
                        Button("次へ") {
                            moveForward()
                        }
                    }
                }
            }
        }
        .onDisappear {
            projectListViewModel.loadProjects()
        }
    }

    private func moveForward() {
        switch currentStep {
        case .inputWords:
            if viewModel.firstThreeWords.split(separator: " ").count >= 3 {
                currentStep = .start
            } else {
                viewModel.statusMessage = "3単語以上入力してください"
            }

        case .start:
            let startMs = waveformVM.selectedTimeMs
            if startMs >= 0 {
                viewModel.startTimeMs = String(startMs)
                currentStep = .end
                print("✂️Trimming starts from \(String(viewModel.startTimeMs))ms")
                
            } else {
                viewModel.statusMessage = "無効な開始時間です"
            }

        case .end:
            break
        }
    }

    private func moveBackward() {
        switch currentStep {
        case .end:
            currentStep = .start
        case .start:
            currentStep = .inputWords
        case .inputWords:
            break
        }
    }
}
