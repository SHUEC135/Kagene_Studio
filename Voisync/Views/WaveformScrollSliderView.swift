//
//  SliderView.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/13.
//

// WaveformScrollSliderView.swift
//
//  SliderView.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/13.
//

// WaveformScrollSliderView.swift
import SwiftUI

struct WaveformScrollSliderView: View {
    @ObservedObject private var vm: WaveformScrollSliderViewModel
    private let secondsPerScreen: Double
    private let barHeight: CGFloat = 300
    private let filePath: String
    
    /// - Parameter filePath: ローカル音源ファイルのパス文字列
    init(
        filePath: String,
        secondsPerScreen: Double = 4.0,
        vm: WaveformScrollSliderViewModel
    ) {
        self.secondsPerScreen = secondsPerScreen
        self.vm = vm
        self.filePath = filePath
    }
    
    var body: some View {
        VStack(spacing: 8) {
            GeometryReader { geo in
                let ratio = vm.duration / secondsPerScreen
                let waveformWidth = geo.size.width * CGFloat(ratio)
                
                
                ZStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            // 左余白 = 画面幅/2
                            Color.clear
                                .frame(width: geo.size.width / 2)
                            
                            // 波形プレースホルダー (あとで実データ描画に置き換え)
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: waveformWidth/2,
                                           height: barHeight)
                                    .background(
                                        GeometryReader { proxy in
                                            Color.clear
                                                .preference(
                                                    key: ScrollOffsetKey.self,
                                                    // proxy.frame(in: .named("wave")) の origin.x を渡す
                                                    value: proxy.frame(in: .named("wave")).origin.x
                                                )
                                        }
                                    )
                                // 右余白 = 画面幅/2
                                WaveformView(fileURL: URL(fileURLWithPath: filePath))
                            }
                            
                            Color.clear
                                .frame(width: geo.size.width / 2)
                            
                        }
                    }
                    .coordinateSpace(name: "wave")
                    .onPreferenceChange(ScrollOffsetKey.self) { originX in
                        let leftPad = geo.size.width / 2
                        // contentOffset.x に相当する値を計算
                        let contentOffset = leftPad - originX
                        vm.updateTime(offsetX: contentOffset,
                                      waveformWidth: waveformWidth)
                    }
                    
                    // 中央固定の青いライン
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 2, height: barHeight)
                        .foregroundColor(.primary)
                    
                }
            }
            .frame(height: barHeight)
            
            
            
            
            
            .padding()
            
            Text(vm.displayTime)
                .font(.title.weight(.bold))
                .foregroundColor(.primary)
            // もしくは .font(.system(.caption, design: .monospaced))
                .monospacedDigit()           // ← これで数字を等幅に
                .padding()
            
                .padding()
            Button(action: {
                if vm.isPlaying {
                    vm.pause()
                } else {
                    vm.play()
                }
            }) {
                Image(systemName: vm.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 96))
                    .foregroundColor(.primary)
            }
            .padding(.horizontal)
            
            // mm:ss.SS 表示

        }
        
    }
    
    
    private struct ScrollOffsetKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
}
