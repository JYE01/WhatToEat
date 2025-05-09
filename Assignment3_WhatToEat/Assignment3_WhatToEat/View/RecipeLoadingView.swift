// RecipeLoadingView.swift
//
//  RecipeLoadingView.swift
//  Assignment3_WhatToEat
//
//  Created by Aranth Tjandra on 6/5/2025.
//

import SwiftUI

struct RecipeLoadingView: View {
    @State private var isAnimating = false
    var onFinishedLoading: () -> Void
    
    let animationDuration: Double = 0.8

    var body: some View {
        ZStack {
            Color.appBackground.edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                Text("Finding Recipes...")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.appPrimaryOrange)

                HStack(spacing: 15) {
                    Circle()
                        .fill(Color.appLightOrange)
                        .frame(width: 15, height: 15)
                        .scaleEffect(isAnimating ? 1.0 : 0.5)
                        .animation(
                            .easeInOut(duration: animationDuration).repeatForever().delay(0),
                            value: isAnimating
                        )
                    Circle()
                        .fill(Color.appLightOrange)
                        .frame(width: 15, height: 15)
                        .scaleEffect(isAnimating ? 1.0 : 0.5)
                        .animation(
                            .easeInOut(duration: animationDuration).repeatForever().delay(animationDuration / 3),
                            value: isAnimating
                        )
                    Circle()
                        .fill(Color.appLightOrange)
                        .frame(width: 15, height: 15)
                        .scaleEffect(isAnimating ? 1.0 : 0.5)
                        .animation(
                            .easeInOut(duration: animationDuration).repeatForever().delay(animationDuration * 2 / 3),
                            value: isAnimating
                        )
                }
            }
        }
        .onAppear {
            isAnimating = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.onFinishedLoading()
            }
        }
    }
}

struct RecipeLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeLoadingView(onFinishedLoading: { print("Loading finished in preview") })
            .preferredColorScheme(.light)
    }
}
