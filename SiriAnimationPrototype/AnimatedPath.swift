//
//  AnimatedPath.swift
//  SiriAnimationPrototype
//
//  Created by Siddhant Mehta on 2024-06-13.
//

import SwiftUI

struct AnimatedRectangle: Shape {
    var size: CGSize
    var padding: Double = 8.0
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
                x: point.x + 10 * sin(t + point.y * 0.1),
                y: point.y + 10 * sin(t + point.x * 0.1)
            )
        }

        // Animate the arc centers
//        let arcCenters = initialArcCenters.map { center in
//            CGPoint(
//                x: center.x + 10 * sin(t + center.y * 0.3),
//                y: center.y + 10 * sin(t + center.x * 0.3)
//            )
//        }

        // Draw the path
        path.move(to: CGPoint(x: padding, y: padding + radius))

        // Top-left corner
//        path.addArc(center: arcCenters[0], radius: radius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)

        // Top edge
        for point in points[0...2] {
            path.addLine(to: point)
        }

        // Top-right corner
//        path.addArc(center: arcCenters[1], radius: radius, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)

        // Right edge
        for point in points[4...7] {
            path.addLine(to: point)
        }

        // Bottom-right corner
//        path.addArc(center: arcCenters[2], radius: radius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)

        // Bottom edge
        for point in points[8...10] {
            path.addLine(to: point)
        }

        // Bottom-left corner
//        path.addArc(center: arcCenters[3], radius: radius, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)

        // Left edge
        for point in points[11...14] {
            path.addLine(to: point)
        }

        path.closeSubpath()

        return path
    }
}
