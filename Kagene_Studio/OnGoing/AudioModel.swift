//
//  AudioModel.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/08.
//

import Foundation

struct AudioProject: Identifiable {
    let id = UUID()
    let name: String                // Project name
    var files: [AudioFile]         // Trimmed audio files
}

struct AudioFile: Identifiable {
    let id = UUID()
    let name: String               // File name like "I don't know.m4a"
    let url: URL                   // File URL
}
