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
    var fileName: String
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()    // SafeArea まで塗りつぶし
            VStack(spacing: 24) {
                ZStack {
                    // Background card
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)

                    // Content
                    VStack(spacing: 24) {
                        Text("モデル音源")
                            .font(.title2.weight(.semibold))
                            .foregroundColor(.primary)

                        Text((fileName as NSString).deletingPathExtension)
                            .font(.title2.weight(.medium))
                            .foregroundColor(.secondary)

                        AudioPlayerView(filePath: filePath)

                        
                    }
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16))
                }
                ZStack {
                    // Background card
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    RecordingView()
                }

            }
            .padding()

        }
    }
}

//#Preview {
//    ShadowingView()
//}
