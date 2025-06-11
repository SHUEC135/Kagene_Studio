//
//  AudioFilePickerView.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/06.
//

import SwiftUI

struct NewProjectButtonView: View {
    @State private var showPicker = false
    @State private var savedFileURL: URL?
    
    @EnvironmentObject var viewModel: ProjectListViewModel
    var onProjectAdded: () -> Void

    var body: some View {
        VStack {
            Button(action: {
                showPicker = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                    Text("新しいプロジェクトを追加")
                        .font(.system(size: 16))
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(Color.blue)
            .clipShape(Capsule())
            .padding(.horizontal)

            if let savedFileURL = savedFileURL {
                Text("Saved to: \(savedFileURL.lastPathComponent)")
                    .font(.caption)
            }
        }
        .sheet(isPresented: $showPicker) {
            DocumentPicker { savedURL in
                self.savedFileURL = savedURL
                onProjectAdded()
            }
            .environmentObject(viewModel)
        }
    }
}
