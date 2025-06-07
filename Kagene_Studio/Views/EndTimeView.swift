//
//  EndTimeView.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/07.
//

import SwiftUI

struct EndTimeView: View {
    @ObservedObject var viewModel: TrimAudioViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Enter End Time (ms)")
            TextField("End Time", text: $viewModel.endTimeMs)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Trim Audio") {
                viewModel.trimAudio()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)

            Text(viewModel.statusMessage)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
