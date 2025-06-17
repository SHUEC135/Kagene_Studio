import SwiftUI

struct WaveformScrollSliderView: View {
    @StateObject private var vm: WaveformScrollSliderViewModel
    private let contentRatio: CGFloat = 3
    private let barHeight: CGFloat = 300

    init(filePath: String) {
        _vm = StateObject(wrappedValue: WaveformScrollSliderViewModel(filePath: filePath))
    }

    var body: some View {
        VStack(spacing: 8) {
            GeometryReader { geo in
                let totalW = geo.size.width * contentRatio
                let centerX = geo.size.width / 2

                ZStack {
                    // 波形プレースホルダー
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: totalW, height: barHeight)
                        // 再生位置に合わせて自動オフセット
                        .offset(x: centerX - CGFloat(vm.progress) * totalW)
                        .clipped()
                    
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 2, height: barHeight)
                        .position(x: centerX, y: barHeight / 2)
                }
            }
            .frame(height: barHeight)

            Button {
                if vm.isPlaying {
                    vm.pause()
                } else {
                    vm.play()
                }
            } label: {
                Image(systemName: vm.isPlaying ? "pause.fill" : "play.fill")
                    .font(.title2)
            }
            .padding(.horizontal)

            // ✨ ここが滑らかシーク用の Slider ✨
            Slider(
                value: Binding(
                    get: { vm.progress },
                    set: { newVal in vm.seek(to: newVal) }
                ),
                in: 0...1
            )
            .padding(.horizontal)

            Text(vm.displayTime)
                .font(.caption)
                .monospacedDigit()
                .padding()
        }
    }
}
