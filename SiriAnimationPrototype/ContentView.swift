//
//  ContentView.swift
//  SiriAnimationPrototype
//
//  Created by Siddhant Mehta on 2024-06-13.
//

import SwiftUI

struct ContentView: View {
    enum SiriState {
        case none
        case thinking
        case answered
    }
    
    @State var state: SiriState = .none
    @State var timer: Timer?
    @State private var maskTimer: Float = 0.0
    
    var computedPadding: CGFloat {
        switch state {
        case .none: 0
        case .thinking: 12
        case .answered: 4
        }
    }
    
    var rectangleSpeed: Float {
        switch state {
        case .none: 0
        case .thinking: 0.1
        case .answered: 0.02
        }
    }
    
    var gradientSpeed: Float {
        switch state {
        case .none: 0
        case .thinking: 0.05
        case .answered: 0.01
        }
    }
    
    var animatedMaskBlur: CGFloat {
        switch state {
        case .none: 8
        case .thinking: 24
        case .answered: 16
        }
    }
    
    var containerPpacity: CGFloat {
        switch state {
        case .none: 0
        case .thinking, .answered: 1.0
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                meshGradient
                    .scaleEffect(1.5) // avoids masks clipping
                    .opacity(containerPpacity)
                
                phoneBackground
                    .mask {
                        animatedRectanle(proxy: geometry, t: CGFloat(maskTimer))
                            .blur(radius: animatedMaskBlur)
                    }
            }
        }
        .ignoresSafeArea()
    }
    
    private func animatedRectanle(proxy: GeometryProxy, t: CGFloat) -> some View {
        AnimatedRectangle(size: proxy.size, padding: computedPadding, cornerRadius: 48, t: t)
            .frame(width: proxy.size.width, height: proxy.size.height)
    }
    
    private var phoneBackground: some View {
        VStack {
            siriButton(text: "Start", action: { self.state = .thinking })
            siriButton(text: "Answered", action: { self.state = .answered })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.white)
    }
    
    private func siriButton(text: String, action: @escaping () -> Void) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 1)) {
                action()
            }
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

            [sinInRange(-0.8...(-0.2), offset: 0.439, timeScale: 0.342, t: maskTimer), sinInRange(0.3...0.7, offset: 3.42, timeScale: 0.984, t: maskTimer)],
            [sinInRange(0.1...0.8, offset: 0.239, timeScale: 0.084, t: maskTimer), sinInRange(0.2...0.8, offset: 5.21, timeScale: 0.242, t: maskTimer)],
            [sinInRange(1.0...1.5, offset: 0.939, timeScale: 0.084, t: maskTimer), sinInRange(0.4...0.8, offset: 0.25, timeScale: 0.642, t: maskTimer)],
            [sinInRange(-0.8...0.0, offset: 1.439, timeScale: 0.442, t: maskTimer), sinInRange(1.4...1.9, offset: 3.42, timeScale: 0.984, t: maskTimer)],
            [sinInRange(0.3...0.6, offset: 0.339, timeScale: 0.784, t: maskTimer), sinInRange(1.0...1.2, offset: 1.22, timeScale: 0.772, t: maskTimer)],
            [sinInRange(1.0...1.5, offset: 0.939, timeScale: 0.056, t: maskTimer), sinInRange(1.3...1.7, offset: 0.47, timeScale: 0.342, t: maskTimer)]
        ], colors: [
            .red, .purple, .indigo,
            .orange, .red, .blue,
            .yellow, .green, .mint
        ])
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                DispatchQueue.main.async {
                    maskTimer += gradientSpeed
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
