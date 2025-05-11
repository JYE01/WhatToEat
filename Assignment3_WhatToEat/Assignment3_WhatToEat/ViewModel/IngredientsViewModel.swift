//
//  IngredientsViewModel.swift
//  Assignment3_WhatToEat
//
//  Created by Felix on 10/5/2025.
//

import Foundation
import SwiftUI

// ViewModel for IngredientsView using ObservableObject (MVVM pattern)
class IngredientsViewModel: ObservableObject {
    
    // Storage for ingredient list using AppStorage for persistence
    @AppStorage("ingredientStorage") private var ingredientStorage: String = ""

    // List of ingredients currently added by the user
    @Published var ingredients: [String] = []

    // The ingredient being typed in the TextField
    @Published var newIngredient: String = ""

    // Controls whether the loading screen should be shown
    @Published var showLoading: Bool = false

    // Triggers navigation to the RecipeView
    @Published var navigateToRecipes: Bool = false

    // The actual ViewModel instance passed to RecipeView after data is ready
    @Published var recipeViewModel: RecipeViewModel? = nil

    // Loads ingredients from local storage during initialization
    init() {
        loadIngredients()
    }

    // Adds a new trimmed ingredient and saves the list
    func addIngredient() {
        let trimmed = newIngredient.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            ingredients.append(trimmed)
            newIngredient = "" // Reset the input field
            saveIngredients()
        }
    }

    // Removes ingredients from the list and saves changes
    func removeIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
        saveIngredients()
    }

    // Loads ingredients from AppStorage JSON string
    private func loadIngredients() {
        if let data = ingredientStorage.data(using: .utf8),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            ingredients = decoded
        }
    }

    // Saves the current ingredients list into AppStorage as JSON
    private func saveIngredients() {
        if let data = try? JSONEncoder().encode(ingredients),
           let json = String(data: data, encoding: .utf8) {
            ingredientStorage = json
        }
    }

    // Starts the loading screen and initializes the recipe view model
    func startLoadingSequence() {
        showLoading = true

        // Create and fetch recipe data
        let vm = RecipeViewModel()
        self.recipeViewModel = vm

        vm.fetchRecipes {
            // Delay briefly to show loading animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.finishLoadingSequence()
            }
        }
    }

    // Ends loading and triggers navigation to the RecipeView
    func finishLoadingSequence() {
        showLoading = false
        navigateToRecipes = true
    }
}
