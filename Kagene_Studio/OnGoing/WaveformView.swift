//
//  WaveformView.swift
//  Kagene_Studio
//
//  Created by 本多真一朗 on 2025/06/17.
//
import SwiftUI

struct WaveformView: View {
    @StateObject private var vm = WaveformViewModel()
    let fileURL: URL

    var body: some View {
        GeometryReader { geo in
            Canvas { ctx, size in
                guard !vm.samples.isEmpty else { return }
                let h = size.height
                let w = size.width
                let step = w / CGFloat(vm.samples.count)
                var path = Path()

                // 中央線を基準に上下に線を引く
                for (idx, amp) in vm.samples.enumerated() {
                    let x = CGFloat(idx) * step
                    let y = h * 0.5
                    let yOffset = CGFloat(amp) * (h * 0.5)
                    path.move(to: .init(x: x, y: y - yOffset))
                    path.addLine(to: .init(x: x, y: y + yOffset))
                }
                ctx.stroke(path, with: .color(.primary), lineWidth: 1)
            }
            .onAppear {
                vm.loadWaveform(filePath: fileURL.path)
            }
        }
    }
}
