import SwiftUI
import Foundation
import AVFoundation

final class WaveformScrollSliderViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var selectedTimeMs: Int = 0
    @Published var displayTime: String = "0:00.00"
    @Published var isPlaying: Bool = false
    
    var duration: Double = 0
    
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?    // ← タイマー用プロパティ追加

    init(filePath: String) {
        super.init()
        //───(1) オーディオセッション設定───────────────────────────
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("🔴 AudioSession error:", error)
        }
        
        //───(2) ファイル URL の組み立て & 存在チェック───────────────
        let url: URL
        if FileManager.default.fileExists(atPath: filePath) {
            url = URL(fileURLWithPath: filePath)
        } else if let bundleURL = Bundle.main.url(forResource: filePath, withExtension: nil) {
            url = bundleURL
        } else {
            fatalError("🔴 Audio file not found at path: \(filePath)")
        }
        
        //───(3) AVAudioPlayer の初期化──────────────────────────────
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            player.prepareToPlay()
            self.audioPlayer = player
            self.duration = player.duration
            print("✅ Loaded audio, duration: \(player.duration)s")
        } catch {
            fatalError("🔴 AVAudioPlayer init error: \(error)")
        }

        updateDisplayTime(ms: 0)
    }
    
    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("🔴 didFinishPlaying – stopping timer")
        stopTimer()
    }

    // MARK: 再生／一時停止
    func play() {
        guard let player = audioPlayer else {
            print("🔴 play(): audioPlayer is nil")
            return
        }
        isPlaying = true
        // 現在の selectedTimeMs から再生
        player.currentTime = Double(selectedTimeMs) / 1000.0
        player.play()
        print("▶️ play() called at \(player.currentTime)s")
        
        startTimer()  // ← タイマー開始
    }

    func pause() {
        guard let player = audioPlayer else {
            print("🔴 pause(): audioPlayer is nil")
            return
        }
        isPlaying = false
        player.pause()
        print("⏸ pause() called at \(player.currentTime)s")
        
        stopTimer()   // ← タイマー停止
    }
    
    // MARK: タイマー制御
    private func startTimer() {
        stopTimer()
        // 0.05秒ごとに再生位置を取得してUIを更新
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.audioPlayer else { return }
            
            // ① 再生末尾到達チェック
            if player.currentTime >= self.duration {
                self.stopTimer()
                // 必要なら最後のフレームを表示
                self.selectedTimeMs = Int((self.duration * 1000).rounded())
                self.updateDisplayTime(ms: self.selectedTimeMs)
                return
            }
            
            // ② 通常の進捗更新
            let ms = Int((player.currentTime * 1000).rounded())
            self.selectedTimeMs = ms
            self.updateDisplayTime(ms: ms)
            // ※ここでスクロール位置を更新するためのコールバック等を呼び出せるように拡張しておくと次ステップが楽です
        }
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    private func stopTimer() {
        print("🛑 stopTimer() called – invalidating timer")
        timer?.invalidate()
        timer = nil
    }

    // MARK: 既存スクロール更新
    func updateTime(offsetX: CGFloat, waveformWidth: CGFloat) {
        // 0…1 に正規化
        let ratio = min(max(Double(offsetX / waveformWidth), 0), 1)
        let ms = Int((ratio * duration * 1000).rounded())
        selectedTimeMs = ms
        updateDisplayTime(ms: ms)

        // ── ここでオーディオプレーヤーの再生位置を更新 ──
        if let player = audioPlayer {
            if player.isPlaying {
                player.currentTime = Double(ms) / 1000.0
            }
        }
    }
    
    private func updateDisplayTime(ms: Int) {
        let centi = ms / 10
        let m = centi / 6000
        let s = (centi % 6000) / 100
        let cs = centi % 100
        displayTime = String(format: "%d:%02d.%02d", m, s, cs)
    }
}
