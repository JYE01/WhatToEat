//
//  RecipeDetailView.swift
//  Assignment3_WhatToEat
//
//  Created by Felix on 4/5/2025.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Image
                AsyncImage(url: URL(string: recipe.image)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(height: 240)
                .clipped()
                .cornerRadius(10)

                // Name & Cuisine
                Text(recipe.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Cuisine: \(recipe.cuisine)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                // Ingredients
                Text("Ingredients")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(recipe.ingredients.joined(separator: ", "))
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)

                Divider()

                // Description
                Text("Description")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(recipe.description)
                    .font(.body)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Recipe Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

