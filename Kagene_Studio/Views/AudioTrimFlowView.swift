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
    @StateObject private var sliderViewModel: WaveformScrollSliderViewModel
    @State private var currentStep: Step = .inputWords
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var projectListViewModel: ProjectListViewModel

    init(filePath: String) {
        self.filePath = filePath
        _viewModel = StateObject(wrappedValue: AudioTrimViewModel(filePath: filePath))
        _sliderViewModel = StateObject(wrappedValue: WaveformScrollSliderViewModel(filePath: filePath))
    }

    enum Step {
        case inputWords
        case start
        case end
    }

    private func formatTime(_ ms: Double) -> String {
        let totalMs = Int(ms)
        let minutes = totalMs / 60000
        let seconds = (totalMs % 60000) / 1000
        let hundredths = (totalMs % 1000) / 10
        return String(format: "%02d:%02d.%02d", minutes, seconds, hundredths)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                switch currentStep {
                case .inputWords:
                    VStack(spacing: 10) {
                        Text("最初の3単語を入力")
                            .font(.headline)
                        TextField("例: When I was", text: $viewModel.firstThreeWords)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                case .start:
                    VStack {
                        Text("Enter Start Time (ms)")
                        WaveformScrollSliderView(filePath: filePath)
                        Text("Selected Start Time: \(sliderViewModel.selectedTimeMs)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                case .end:
                    VStack {
                        Text("Enter End Time (ms)")
                        TextField("End Time", text: $viewModel.endTimeMs)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button("Trim Audio") {
                            viewModel.trimAudio()
                            dismiss()
                        }
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
                    if currentStep != .end {
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
            viewModel.startTimeMs = String(sliderViewModel.selectedTimeMs)
            if sliderViewModel.selectedTimeMs >= 0 {
                currentStep = .end
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
