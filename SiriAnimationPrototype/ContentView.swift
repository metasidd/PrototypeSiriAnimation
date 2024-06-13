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
    }
    
    @State var counter: Int = 0
    @State var origin: CGPoint = .init(x: 0.5, y: 0.5)
    
    @State var state: SiriState = .thinking
    @State var timer: Timer?
    @State private var maskTimer: Float = 0.0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                MeshGradientView(gradientSpeed: gradientSpeed)
                    .scaleEffect(1.5) // avoids masks clipping
                    .opacity(containerOpacity)
                
                RoundedRectangle(cornerRadius: 52, style: .continuous)
                    .stroke(Color.white, style: .init(lineWidth: 4))
                    .blur(radius: 8)
                
                PhoneBackground(state: $state, origin: $origin, counter: $counter)
                    .mask {
                        AnimatedRectangle(size: geometry.size, cornerRadius: 48, t: CGFloat(maskTimer))
                            .scaleEffect(computedScale)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .blur(radius: animatedMaskBlur)
                    }
            }
        }
        .ignoresSafeArea()
        .modifier(RippleEffect(at: origin, trigger: counter))
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                DispatchQueue.main.async {
                    maskTimer += rectangleSpeed
                }
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private var computedScale: CGFloat {
        switch state {
        case .none: return 1.1
        case .thinking: return 1
        }
    }
    
    private var rectangleSpeed: Float {
        switch state {
        case .none: return 0
        case .thinking: return 0.05
        }
    }
    
    private var gradientSpeed: Float {
        switch state {
        case .none: return 0
        case .thinking: return 0.05
        }
    }
    
    private var animatedMaskBlur: CGFloat {
        switch state {
        case .none: return 8
        case .thinking: return 24
        }
    }
    
    private var containerOpacity: CGFloat {
        switch state {
        case .none: return 0
        case .thinking: return 1.0
        }
    }
}


#Preview {
    ContentView()
}
