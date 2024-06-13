//
//  ContentView.swift
//  SiriAnimationPrototype
//
//  Created by Siddhant Mehta on 2024-06-13.
//

import SwiftUI

struct ContentView: View {
    @State var t: Float = 0.0
    @State var t2: Float = 0.0
    @State var timer: Timer?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                meshGradient
                    .blur(radius: 8)
                
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
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(Color.white)
            .ignoresSafeArea()
    }

    private var phoneMask: some View {
        RoundedRectangle(cornerRadius: 49, style: .continuous)
            .fill(Color.white)
            .ignoresSafeArea()
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
            .orange, .white, .blue,
            .yellow, .green, .mint
        ])
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                DispatchQueue.main.async {
                    t += 0.06
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

struct AnimatedRectangle: Shape {
    var size: CGSize
    var cornerRadius: CGFloat
    var t: CGFloat

    var animatableData: CGFloat {
        get { t }
        set { t = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = size.width
        let height = size.height
        let padding: CGFloat = 16
        let radius = cornerRadius

        // Define the initial points
        let initialPoints = [
            CGPoint(x: padding + radius, y: padding),
            CGPoint(x: width * 0.25 + padding, y: padding),
            CGPoint(x: width * 0.75 + padding, y: padding),
            CGPoint(x: width - padding - radius, y: padding),
            CGPoint(x: width - padding, y: padding + radius),
            CGPoint(x: width - padding, y: height * 0.25 - padding),
            CGPoint(x: width - padding, y: height * 0.75 - padding),
            CGPoint(x: width - padding, y: height - padding - radius),
            CGPoint(x: width - padding - radius, y: height - padding),
            CGPoint(x: width * 0.75 - padding, y: height - padding),
            CGPoint(x: width * 0.25 - padding, y: height - padding),
            CGPoint(x: padding + radius, y: height - padding),
            CGPoint(x: padding, y: height - padding - radius),
            CGPoint(x: padding, y: height * 0.75 - padding),
            CGPoint(x: padding, y: height * 0.25 - padding),
            CGPoint(x: padding, y: padding + radius)
        ]

        // Define the arc centers
        let initialArcCenters = [
            CGPoint(x: padding + radius, y: padding + radius), // Top-left
            CGPoint(x: width - padding - radius, y: padding + radius), // Top-right
            CGPoint(x: width - padding - radius, y: height - padding - radius), // Bottom-right
            CGPoint(x: padding + radius, y: height - padding - radius) // Bottom-left
        ]

        // Animate the points
        let points = initialPoints.map { point in
            CGPoint(
                x: point.x + 10 * sin(t + point.y * 0.2),
                y: point.y + 10 * sin(t + point.x * 0.2)
            )
        }

        // Animate the arc centers
        let arcCenters = initialArcCenters.map { center in
            CGPoint(
                x: center.x + 10 * sin(t + center.y * 0.01),
                y: center.y + 10 * sin(t + center.x * 0.01)
            )
        }

        // Draw the path
        path.move(to: CGPoint(x: padding, y: padding + radius))

        // Top-left corner
        path.addArc(center: arcCenters[0], radius: radius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)

        // Top edge
        for point in points[0...2] {
            path.addLine(to: point)
        }

        // Top-right corner
        path.addArc(center: arcCenters[1], radius: radius, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)

        // Right edge
        for point in points[4...7] {
            path.addLine(to: point)
        }

        // Bottom-right corner
        path.addArc(center: arcCenters[2], radius: radius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)

        // Bottom edge
        for point in points[8...10] {
            path.addLine(to: point)
        }

        // Bottom-left corner
        path.addArc(center: arcCenters[3], radius: radius, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)

        // Left edge
        for point in points[11...14] {
            path.addLine(to: point)
        }

        path.closeSubpath()

        return path
    }
}


#Preview {
    ContentView()
}
