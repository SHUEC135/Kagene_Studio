//
//  AudioTrimFlowView.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/07.
//

import SwiftUI

struct AudioTrimFlowView: View {
    @StateObject private var viewModel = TrimAudioViewModel()
    @State private var currentStep: Step = .inputWords

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
                            .font(.headline)
                        TextField("例: Apple Banana Cat", text: $viewModel.firstThreeWords)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                case .start:
                    VStack {
                        Text("Enter Start Time (ms)")
                        TextField("Start Time", text: $viewModel.startTimeMs)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                case .end:
                    VStack {
                        Text("Enter End Time (ms)")
                        TextField("End Time", text: $viewModel.endTimeMs)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button("Trim Audio") {
                            viewModel.trimAudio()
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
            if let start = Double(viewModel.startTimeMs), start >= 0 {
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
