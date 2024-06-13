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
    
    @State var state: SiriState = .none
    @State var timer: Timer?
    @State private var maskTimer: Float = 0.0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                MeshGradientView(gradientSpeed: gradientSpeed)
                    .scaleEffect(1.5) // avoids masks clipping
                    .opacity(containerOpacity)
                
                phoneBackground
                    .mask {
                        AnimatedRectangle(size: geometry.size, cornerRadius: 48, t: CGFloat(maskTimer))
                            .scaleEffect(computedScale)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .blur(radius: animatedMaskBlur)
                    }
            }
        }
        .ignoresSafeArea()
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
    
    private var phoneBackground: some View {
        VStack {
            siriButton(text: "Start", action: {
                self.state = .thinking
            })
            siriButton(text: "Stop", action: {
                self.state = .none
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.white)
    }
    
    private func siriButton(text: String, action: @escaping () -> Void) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.9)) {
                action()
            }
        } label: {
            Text(text)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .font(.system(.body, design: .monospaced))
                .background(
                    RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                        .fill(Color.gray.opacity(0.1))
                )
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
