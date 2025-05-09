//
//  LaunchView.swift
//  Assignment3_WhatToEat
//
//  Created by Aranth Tjandra on 1/5/2025.
//

import SwiftUI

// Spinning Logo View
struct LaunchView: View {
    @State private var rotationAngle: Double = 0
    let logoName: String = "logo"
    let frameSize: CGFloat? = 150

    var body: some View {
        Image(logoName)
            .resizable()
            .scaledToFit()
            .ifLet(frameSize) { view, size in
                view.frame(width: size, height: size)
            }
            .rotationEffect(.degrees(rotationAngle))
            .onAppear(perform: startAnimationLoop)
    }

    private func startAnimationLoop() {
        withAnimation(.linear(duration: 1.0)) {
            rotationAngle += 360
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            startAnimationLoop()
        }
    }
}

extension View {
    @ViewBuilder
    func ifLet<T, Content: View>(_ value: T?, modifier: (Self, T) -> Content) -> some View {
        if let value = value {
            modifier(self, value)
        } else {
            self
        }
    }
}

// Preview
struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
