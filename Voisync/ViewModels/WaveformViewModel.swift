//
//  WaveformViewModel.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/17.
//
import SwiftUI
import AVFoundation

/// 波形データを保持する ViewModel
class WaveformViewModel: ObservableObject {
    @Published var samples: [Float] = []

    /// ファイルパス（Bundle内でもドキュメントフォルダ内でもOK）から波形データを読み込む
    /// - Parameters:
    ///   - filePath: ローカルのファイルパス文字列
    ///   - sampleCount: 出力するサンプル数
    func loadWaveform(filePath: String, sampleCount: Int = 1000) {
        // 文字列パスを URL に変換
        let fileURL = URL(fileURLWithPath: filePath)
        let asset = AVURLAsset(url: fileURL)
        guard
            let track = asset.tracks(withMediaType: .audio).first,
            let reader = try? AVAssetReader(asset: asset)
        else { return }

        // 出力設定：PCM Float32, モノラル
        let outputSettings: [String: Any] = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVLinearPCMIsFloatKey: true,
            AVLinearPCMBitDepthKey: 32,
            AVLinearPCMIsNonInterleaved: false,
            AVNumberOfChannelsKey: 1
        ]
        let output = AVAssetReaderTrackOutput(track: track, outputSettings: outputSettings)
        reader.add(output)
        reader.startReading()

        // 全サンプルを読み出し
        var fullSamples = [Float]()
        while let buffer = output.copyNextSampleBuffer(),
              let blockBuffer = CMSampleBufferGetDataBuffer(buffer) {
            let length = CMBlockBufferGetDataLength(blockBuffer)
            var data = Data(count: length)
            data.withUnsafeMutableBytes { ptr in
                CMBlockBufferCopyDataBytes(blockBuffer, atOffset: 0, dataLength: length, destination: ptr.baseAddress!)
            }
            // Float32 として解釈
            let floatCount = length / MemoryLayout<Float>.size
            data.withUnsafeBytes { ptr in
                let floats = ptr.bindMemory(to: Float.self)
                fullSamples.append(contentsOf: floats)
            }
            CMSampleBufferInvalidate(buffer)
        }

        // ダウンサンプリング：区間ごとに最大振幅を取る
        let samplesPerPixel = max(1, fullSamples.count / sampleCount)
        var downSamples = [Float]()
        for i in stride(from: 0, to: fullSamples.count, by: samplesPerPixel) {
            let segment = fullSamples[i..<min(i+samplesPerPixel, fullSamples.count)]
            let peak = segment.map(abs).max() ?? 0
            downSamples.append(peak)
        }

        DispatchQueue.main.async {
            self.samples = downSamples
        }
    }
}
