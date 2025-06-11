//
//  Untitled.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/07.
//

import Foundation
import AVFoundation

enum AudioTrimError: Error {
    case exportFailed
    case invalidOutput
}

struct AudioTrimmer {
    static func trimAudio(sourceURL: URL, startTime: CMTime, endTime: CMTime, fileName: String) async throws -> URL {
        let asset = AVURLAsset(url: sourceURL)

        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
            throw AudioTrimError.exportFailed
        }

        let sanitizedFileName = fileName
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "[/:*?\"<>|]", with: "_", options: .regularExpression) // Remove invalid chars

        // Extract project name from sourceURL's parent folder
        let projectName = sourceURL.deletingLastPathComponent().lastPathComponent

        // Create path: Documents/プロジェクト名/Edited/
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let editedFolderURL = documentsURL
            .appendingPathComponent(projectName)
            .appendingPathComponent("Edited")

        // Ensure the Edited folder exists
        try FileManager.default.createDirectory(at: editedFolderURL, withIntermediateDirectories: true)

        // Final output path
        let outputURL = editedFolderURL.appendingPathComponent("\(sanitizedFileName).m4a")

        exportSession.outputURL = outputURL
        exportSession.outputFileType = .m4a
        exportSession.timeRange = CMTimeRange(start: startTime, end: endTime)

        try await exportSession.export()

        if exportSession.status == .completed {
            return outputURL
        } else {
            throw exportSession.error ?? AudioTrimError.exportFailed
        }
    }
}
