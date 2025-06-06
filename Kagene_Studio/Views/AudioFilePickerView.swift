//
//  AudioFilePickerView.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/06.
//

import SwiftUI

struct AudioFilePickerView: View {
    @State private var showPicker = false

    var body: some View {
        Button("Import Audio") {
            showPicker = true
        }
        .sheet(isPresented: $showPicker) {
            DocumentPicker()
        }
    }
}

#Preview {
    AudioFilePickerView()
}
