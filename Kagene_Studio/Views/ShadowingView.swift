//
//  ShadowingView.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/05.
//

import SwiftUI
import Foundation

struct ShadowingView: View {
    var filePath: String
    
    var body: some View {
        AudioPlayerView(filePath: filePath)
        RecordingView()
    }
}

//#Preview {
//    ShadowingView()
//}
