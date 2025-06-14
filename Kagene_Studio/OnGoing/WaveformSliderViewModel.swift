//
//  SliderViewModel.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/13.
//



// WaveformScrollSliderViewModel.swift
import SwiftUI
import AVFoundation

final class WaveformScrollSliderViewModel: ObservableObject {
    // MARK: - Published
    @Published var selectedTimeMs: Int = 0        // ミリ秒単位トリミング開始位置
    @Published var displayTime: String = "0:00.00"// mm:ss.SS 表示用

    // MARK: - Private
    private let duration: Double                  // 音源総再生時間（秒）

    // MARK: - Init
    /// - Parameter filePath: ローカル音源ファイルのパス文字列
    init(filePath: String) {
        let url = URL(fileURLWithPath: filePath)
        let asset = AVAsset(url: url)
        self.duration = CMTimeGetSeconds(asset.duration)
        updateDisplayTime(ms: 0)
    }

    // MARK: - Public
    /// コンテンツ先頭からのスクロール量（offsetX）を受け取り、再生位置を更新
    /// - offsetX: 0…waveformWidth の範囲で渡す
    /// - waveformWidth: 波形コンテンツの幅
    func updateTime(offsetX: CGFloat, waveformWidth: CGFloat) {
        // 0.0 … 1.0 に正規化
        let ratio = min(max(Double(offsetX / waveformWidth), 0), 1)
        let ms = Int((ratio * duration * 1000).rounded())
        selectedTimeMs = ms
        updateDisplayTime(ms: ms)
    }

    // MARK: - Private helpers
    private func updateDisplayTime(ms: Int) {
        let centi = ms / 10
        let m = centi / 6000
        let s = (centi % 6000) / 100
        let cs = centi % 100
        displayTime = String(format: "%d:%02d.%02d", m, s, cs)
    }
}
