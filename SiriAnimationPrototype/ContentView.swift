//
//  ContentView.swift
//  SiriAnimationPrototype
//
//  Created by Siddhant Mehta on 2024-06-13.
//

import SwiftUI

struct ContentView: View {
    @State var t: Float = 0.0
    @State var timer: Timer?
    
    let rectangleSpeed: Float = 0.03
    let gradientSpeed: Float = 0.03

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                meshGradient
                
                phoneBackground
                    .mask {
                        animatedRectanle(proxy: geometry, t: CGFloat(t))
                            .blur(radius: 16)
                    }
            }
        }
        .ignoresSafeArea()
    }
    
    private func animatedRectanle(proxy: GeometryProxy, t: CGFloat) -> some View {
        AnimatedRectangle(size: proxy.size, cornerRadius: 48, t: t)
            .frame(width: proxy.size.width, height: proxy.size.height)
    }
    
    private var phoneBackground: some View {
        VStack {
            siriButton(text: "Start", action: { })
            siriButton(text: "Thinking", action: { })
            siriButton(text: "Stop", action: { })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.white)
    }
    
    private func siriButton(text: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(text)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .fontDesign(.monospaced)
                .background(
                    RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                        .fill(Color.gray.opacity(0.1))
                )
        }
    }
    
    private var meshGradient: some View {
        MeshGradient(width: 3, height: 3, points: [
            .init(0, 0), .init(0.0, 0), .init(1, 0),

            [sinInRange(-0.8...(-0.2), offset: 0.439, timeScale: 0.342, t: t), sinInRange(0.3...0.7, offset: 3.42, timeScale: 0.984, t: t)],
            [sinInRange(0.1...0.8, offset: 0.239, timeScale: 0.084, t: t), sinInRange(0.2...0.8, offset: 5.21, timeScale: 0.242, t: t)],
            [sinInRange(1.0...1.5, offset: 0.939, timeScale: 0.084, t: t), sinInRange(0.4...0.8, offset: 0.25, timeScale: 0.642, t: t)],
            [sinInRange(-0.8...0.0, offset: 1.439, timeScale: 0.442, t: t), sinInRange(1.4...1.9, offset: 3.42, timeScale: 0.984, t: t)],
            [sinInRange(0.3...0.6, offset: 0.339, timeScale: 0.784, t: t), sinInRange(1.0...1.2, offset: 1.22, timeScale: 0.772, t: t)],
            [sinInRange(1.0...1.5, offset: 0.939, timeScale: 0.056, t: t), sinInRange(1.3...1.7, offset: 0.47, timeScale: 0.342, t: t)]
        ], colors: [
            .red, .purple, .indigo,
            .orange, .red, .blue,
            .yellow, .green, .mint
        ])
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                DispatchQueue.main.async {
                    t += gradientSpeed
                }
            }
        }
        .ignoresSafeArea()
    }

    func sinInRange(_ range: ClosedRange<Float>, offset: Float, timeScale: Float, t: Float) -> Float {
        let amplitude = (range.upperBound - range.lowerBound) / 2
        let midPoint = (range.upperBound + range.lowerBound) / 2
        return midPoint + amplitude * sin(timeScale * t + offset)
    }
}


#Preview {
    ContentView()
}
