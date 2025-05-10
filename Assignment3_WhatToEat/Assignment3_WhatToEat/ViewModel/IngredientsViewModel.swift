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
    // Storage for ingredient list using AppStorage for persistence across launches
    @AppStorage("ingredientStorage") private var ingredientStorage: String = ""

    // List of ingredients currently added by the user
    @Published var ingredients: [String] = []

    // The value typed into the TextField by the user
    @Published var newIngredient: String = ""

    // Controls visibility of the loading screen
    @Published var showLoading = false

    // Triggers navigation to the recipe results view
    @Published var navigateToRecipes = false

    // Loads the stored ingredients when the ViewModel is initialized
    init() {
        loadIngredients()
    }

    // Adds a trimmed ingredient to the list and saves it
    func addIngredient() {
        let trimmed = newIngredient.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            ingredients.append(trimmed)
            newIngredient = "" // Clear input field
            saveIngredients()
        }
    }

    // Removes ingredient at specified index and saves updated list
    func removeIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
        saveIngredients()
    }

    // Loads ingredients from AppStorage (if present)
    func loadIngredients() {
        if let data = ingredientStorage.data(using: .utf8),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            ingredients = decoded
        }
    }

    // Saves current ingredient list to AppStorage
    private func saveIngredients() {
        if let data = try? JSONEncoder().encode(ingredients),
           let json = String(data: data, encoding: .utf8) {
            ingredientStorage = json
        }
    }

    // Starts the loading screen sequence
    func startLoadingSequence() {
        showLoading = true
    }

    // Ends loading and navigates to RecipeView
    func finishLoadingSequence() {
        showLoading = false
        navigateToRecipes = true
    }
}
