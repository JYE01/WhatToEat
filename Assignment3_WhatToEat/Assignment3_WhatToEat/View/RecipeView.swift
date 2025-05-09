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

                    // --- Cuisine Filter ---
                    if !availableCuisines.isEmpty {
                        VStack {
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
                            .padding(.top)
                        }
                        .background(Color(.systemBackground))
                        .zIndex(1)
                    }

                    // --- Recipes or No Match Message ---
                    if displayedRecipes.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.orange)

                            if recipeViewModel.unmatchedIngredients.isEmpty {
                                Text("No recipes found based on your selected ingredients.")
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            } else {
                                Text("No recipes found.\nThese ingredients are not used in any recipe:")
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)

                                Text(recipeViewModel.unmatchedIngredients.joined(separator: ", "))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top, 100)
                    } else {
                        ForEach(displayedRecipes) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                VStack(alignment: .leading, spacing: 10) {
                                    Image(recipe.image)
                                        .resizable()
                                        .scaledToFill()
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
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding(.top)
            }
            .background(Color.clear)
            .navigationTitle("Recipes")
        }
    }
}

#Preview {
    RecipeView()
}
