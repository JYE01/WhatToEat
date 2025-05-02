//
//  RecipeView.swift
//  Assignment3_WhatToEat
//
//  Created by Felix on 3/5/2025.
//

import SwiftUI

struct RecipeView: View {
    @ObservedObject private var firestoreManager = FirestoreManager()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(firestoreManager.recipes) { recipe in
                    VStack(alignment: .leading, spacing: 10) {
                        // Recipe Image
                        AsyncImage(url: URL(string: recipe.image)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .frame(height: 180)
                        .clipped()
                        .cornerRadius(10)

                        // Recipe Name
                        Text(recipe.name)
                            .font(.title2)
                            .fontWeight(.bold)

                        // Cuisine
                        Text("Cuisine: \(recipe.cuisine)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .padding(.horizontal)
                }
            }
            .padding(.top)
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            firestoreManager.fetchRecipes()
        }
    }
}

#Preview {
    RecipeView()
}
