//
//  RecipeView.swift
//  Assignment3_WhatToEat
//
//  Created by Felix on 3/5/2025.
//
 
import SwiftUI
 
// The main screen to display recipes filtered by ingredients and optional cuisine type
struct RecipeView: View {
    
    // Observed ViewModel to fetch and filter recipe data
    @ObservedObject private var recipeViewModel = RecipeViewModel()
    
    // Currently selected cuisine filter
    @State private var selectedCuisine: String = "All"
 
    // Returns a sorted list of all unique cuisines from the filtered recipes
    private var availableCuisines: [String] {
        let cuisines = recipeViewModel.filteredRecipes.map { $0.cuisine }
        let unique = Set(cuisines)
        return ["All"] + unique.sorted()
    }
 
    // Returns the recipes to be displayed after applying the selected cuisine filter
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
                        .zIndex(1) // ensures it stacks above other views if needed
                    }
 
                    //If No Recipes Match Filter
                    if displayedRecipes.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.orange)
 
                            //  No recipes matched but all ingredients are valid
                            if recipeViewModel.unmatchedIngredients.isEmpty {
                                Text("No recipes found based on your selected ingredients.")
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            //Some selected ingredients do not exist in any recipe
                            else {
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
                    }
 
                    // If Recipes Found, Display Them as Cards
                    else {
                        ForEach(displayedRecipes) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    // Recipe image
                                    Image(recipe.image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 180)
                                        .clipped()
                                        .cornerRadius(10)
 
                                    // Recipe title
                                    Text(recipe.name)
                                        .font(.title2)
                                        .fontWeight(.bold)
 
                                    // Cuisine label
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
                            .buttonStyle(PlainButtonStyle()) // Prevents highlight effect on tap
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
