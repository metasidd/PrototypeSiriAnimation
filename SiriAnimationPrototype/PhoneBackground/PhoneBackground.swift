//
//  PhoneBackground.swift
//  SiriAnimationPrototype
//
//  Created by Siddhant Mehta on 2024-06-13.
//

import SwiftUI

struct PhoneBackground: View {
    @Binding var state: ContentView.SiriState
    @Binding var origin: CGPoint
    @Binding var counter: Int

    var body: some View {
        VStack {
            siriButton(text: "Start", action: {
                self.state = .thinking
            })
            siriButton(text: "Stop", action: {
                self.state = .none
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.black)
        .onPressingChanged { point in
            if let point {
                origin = point
                counter += 1
            }
        }
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
}
