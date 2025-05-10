//
//  RecipeViewModel.swift
//  Assignment3_WhatToEat
//
//  Created by Felix on 4/5/2025.
//
 
import Foundation
import SwiftUI
import Combine
 
// ViewModel responsible for managing and filtering recipes
class RecipeViewModel: ObservableObject {
    
    // Recipes matching user-selected ingredients
    @Published var filteredRecipes: [Recipe] = []
    
    // All recipes fetched from Firestore
    @Published var allRecipes: [Recipe] = []
 
    // Stored JSON string of selected ingredients from AppStorage
    private var ingredientStorage: String {
        UserDefaults.standard.string(forKey: "ingredientStorage") ?? "[]"
    }
 
    // Firestore manager used to fetch recipe and user data
    private let firestoreManager = FirestoreManager()
 
    // Initialize and fetch recipes on creation
    init() {
        fetchRecipes()
    }
 
    // Fetch all recipes from Firestore, then apply initial filtering
    func fetchRecipes() {
        firestoreManager.fetchRecipes { [weak self] recipes in
            DispatchQueue.main.async {
                self?.allRecipes = recipes
                self?.filterRecipes()
            }
        }
    }
 
    // Normalize an ingredient to its root form (basic singular form).
    // This helps match plural vs singular words (e.g. "carrots" vs "carrot").
    private func normalize(_ ingredient: String) -> String {
        var word = ingredient
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
 
        // Remove "es" if it ends with it (e.g., tomatoes -> tomato)
        if word.hasSuffix("es") {
            word = String(word.dropLast(2))
        }
        // Remove "s" if it ends with it (e.g., onions -> onion)
        else if word.hasSuffix("s") {
            word = String(word.dropLast(1))
        }
 
        return word
    }
 
    // Filters recipes based on selected ingredients.
    // A recipe is included if at least one of the normalized selected ingredients
    // exists in the recipe's normalized ingredient list.
    func filterRecipes() {
        // Decode selected ingredients from JSON stored in AppStorage
        guard let data = ingredientStorage.data(using: .utf8),
              let selectedIngredients = try? JSONDecoder().decode([String].self, from: data),
              !selectedIngredients.isEmpty else {
            self.filteredRecipes = allRecipes
            return
        }
 
        // Normalize the selected ingredients to their base form
        let normalizedSelected = selectedIngredients.map(normalize)
 
        // Filter recipes that contain at least one of the selected ingredients
        self.filteredRecipes = allRecipes.filter { recipe in
            let normalizedRecipeIngredients = recipe.ingredients.map(normalize)
            return normalizedSelected.contains { normalizedRecipeIngredients.contains($0) }
        }
    }
 
    // Retrieves selected ingredients as an array from AppStorage JSON string
    var selectedIngredients: [String] {
        guard let data = ingredientStorage.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([String].self, from: data) else {
            return []
        }
        return decoded
    }
 
    // Finds selected ingredients that are not used in any recipe, after normalizing both the recipe ingredients and user input.
    var unmatchedIngredients: [String] {
        // Collect and normalize all ingredients across all recipes
        let allNormalizedIngredients = allRecipes
            .flatMap { $0.ingredients }
            .map(normalize)
 
        // Return selected ingredients that don’t exist in any recipe's ingredient list
        return selectedIngredients.filter {
            !allNormalizedIngredients.contains(normalize($0))
        }
    }
}
 
