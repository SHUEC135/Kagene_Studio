//
//  StartTimeView.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/07.
//

import SwiftUI

struct StartTimeView: View {
    @StateObject private var viewModel = TrimAudioViewModel()
    @State private var showEndTime = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Start Time (ms)")
            TextField("Start Time", text: $viewModel.startTimeMs)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Next") {
                if let start = Double(viewModel.startTimeMs), start >= 0 {
                    showEndTime = true
                } else {
                    viewModel.statusMessage = "Invalid start time"
                }
            }
            .sheet(isPresented: $showEndTime) {
                EndTimeView(viewModel: viewModel)
            }

            Text(viewModel.statusMessage)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
