//
//  AudioTrimButton.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/07.
//

import SwiftUI

struct AudioTrimButton: View {
    var filePath: String
    @State private var showModal = false

    init(filePath: String) {
        self.filePath = filePath
        print("🎯 AudioTrimButton initialized with filePath: \(filePath)")
    }

    var body: some View {
        Button(action: {
            showModal = true
        }) {
            Image(systemName: "plus")
                .font(.title2) // You can adjust size: .title, .title2, .largeTitle
        }
        .sheet(isPresented: $showModal) {
            AudioTrimFlowView(filePath: filePath)
        }
        .padding()
    }
}
