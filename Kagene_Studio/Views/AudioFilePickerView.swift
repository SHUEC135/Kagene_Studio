//
//  AudioFilePickerView.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/06.
//

import SwiftUI

struct AudioFilePickerView: View {
    @State private var showPicker = false
    @State private var savedFileURL: URL?

    var body: some View {
        VStack {
            Button("Import Audio") {
                showPicker = true
            }

            if let savedFileURL = savedFileURL {
                Text("Saved to: \(savedFileURL.lastPathComponent)")
                    .font(.caption)
            }
        }
        .sheet(isPresented: $showPicker) {
            DocumentPicker { savedURL in
                self.savedFileURL = savedURL
            }
        }
    }
}
