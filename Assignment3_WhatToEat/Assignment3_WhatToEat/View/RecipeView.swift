//
//  RecipeView.swift
//  Assignment3_WhatToEat
//
//  Created by Felix on 3/5/2025.
//

import SwiftUI

struct RecipeView: View {
    @ObservedObject private var recipeViewModel = RecipeViewModel()

    @State private var selectedCuisine: String = "All"

    private var availableCuisines: [String] {
        let cuisines = recipeViewModel.filteredRecipes.map { $0.cuisine }
        let unique = Set(cuisines)
        return ["All"] + unique.sorted()
    }

    private var displayedRecipes: [Recipe] {
        if selectedCuisine == "All" {
            return recipeViewModel.filteredRecipes
        } else {
            return recipeViewModel.filteredRecipes.filter { $0.cuisine == selectedCuisine }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    // Cuisine Filter
                    HStack(alignment: .center, spacing: 12) {
                        Text("Filter by Cuisine:")
                            .font(.headline)

                        Picker("Select Cuisine", selection: $selectedCuisine) {
                            ForEach(availableCuisines, id: \.self) { cuisine in
                                Text(cuisine).tag(cuisine)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(minWidth: 120, maxWidth: 150)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
                    }
                    .padding(.horizontal)

                    // Recipe Cards
                    ForEach(displayedRecipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            VStack(alignment: .leading, spacing: 10) {
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

                                Text(recipe.name)
                                    .font(.title2)
                                    .fontWeight(.bold)

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
                        .buttonStyle(PlainButtonStyle()) // Prevent blue tint on iOS
                    }
                }
                .padding(.top)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Recipes")
        }
    }
}


#Preview {
    RecipeView()
}
