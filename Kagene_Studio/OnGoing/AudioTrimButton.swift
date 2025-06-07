//
//  AudioTrimButton.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/07.
//

import SwiftUI

struct AudioTrimButton: View {
    @State private var showModal = false

    var body: some View {
        Button("Start Trimming") {
            showModal = true
        }
        .sheet(isPresented: $showModal) {
            AudioTrimFlowView()
        }
        .padding()
    }
}
