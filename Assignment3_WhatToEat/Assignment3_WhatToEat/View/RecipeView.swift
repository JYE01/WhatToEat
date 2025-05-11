//
//  RecipeView.swift
//  Assignment3_WhatToEat
//
//  Created by Felix on 3/5/2025.
//
 
import SwiftUI
// The main screen to display recipes filtered by ingredients and optional cuisine type
struct RecipeView: View {
    @ObservedObject var recipeViewModel: RecipeViewModel

    @State private var selectedCuisine: String = "All"
    @State private var selectedRecipe: Recipe? = nil // Used for NavigationLink selection
    @Environment(\.dismiss) var dismiss // Used for 'Home' button to dismiss this view

    // Unique cuisine list for Picker
    private var availableCuisines: [String] {
        let cuisines = recipeViewModel.filteredRecipes.map { $0.cuisine }
        let unique = Set(cuisines)
        return ["All"] + unique.sorted()
    }

    // Recipes shown based on selected cuisine
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
                LazyVStack(spacing: 16) { // LazyVStack improves scrolling performance

                    //Cuisine Filter Picker
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

                    //Error Message for Unmatched Ingredients
                    if recipeViewModel.isDataReady && !recipeViewModel.unmatchedIngredients.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)

                            Text("No recipes found based on your selected ingredients.")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            Text("These ingredients are not used in any recipe:")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .padding(.top, 4)

                            Text(recipeViewModel.unmatchedIngredients.joined(separator: ", "))
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.top, 60)
                    }

                    //Recipe Cards (only shown if all ingredients are matched)
                    else if recipeViewModel.isDataReady {
                        ForEach(displayedRecipes) { recipe in
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
                            .contentShape(Rectangle()) // Ensures full area is tappable
                            .background(
                                NavigationLink(
                                    destination: RecipeDetailView(recipe: recipe),
                                    tag: recipe,
                                    selection: $selectedRecipe,
                                    label: { EmptyView() }
                                )
                                .hidden() // Hidden but functional NavigationLink
                            )
                            .onTapGesture {
                                selectedRecipe = recipe
                            }
                        }
                    }
                }
                .padding(.top)
            }
            .background(Color.clear)
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}



 
#Preview {
    RecipeView(recipeViewModel: RecipeViewModel())
}
