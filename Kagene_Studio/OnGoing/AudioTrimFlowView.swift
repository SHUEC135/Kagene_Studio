//
//  AudioTrimFlowView.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/07.
//

import SwiftUI

struct AudioTrimFlowView: View {
    @StateObject private var viewModel = TrimAudioViewModel()
    @State private var currentStep: Step = .start

    enum Step {
        case start
        case end
    }

    var body: some View {
        VStack(spacing: 20) {
            if currentStep == .start {
                VStack {
                    Text("Enter Start Time (ms)")
                    TextField("Start Time", text: $viewModel.startTimeMs)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button("Next") {
                        if let start = Double(viewModel.startTimeMs), start >= 0 {
                            currentStep = .end
                        } else {
                            viewModel.statusMessage = "Invalid start time"
                        }
                    }
                }
            } else if currentStep == .end {
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
    }
}
