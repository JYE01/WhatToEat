//
//  RecipeViewModel.swift
//  Assignment3_WhatToEat
//
//  Created by Felix on 4/5/2025.
//

import Foundation
import SwiftUI
import Combine

class RecipeViewModel: ObservableObject {
    @Published var filteredRecipes: [Recipe] = []
    @Published var allRecipes: [Recipe] = []

    private var ingredientStorage: String {
        UserDefaults.standard.string(forKey: "ingredientStorage") ?? "[]"
    }

    private let firestoreManager = FirestoreManager()

    init() {
        fetchRecipes()
    }

    func fetchRecipes() {
        firestoreManager.fetchRecipes { [weak self] recipes in
            DispatchQueue.main.async {
                self?.allRecipes = recipes
                self?.filterRecipes()
            }
        }
    }

    func filterRecipes() {
        guard let data = ingredientStorage.data(using: .utf8),
              let selectedIngredients = try? JSONDecoder().decode([String].self, from: data),
              !selectedIngredients.isEmpty else {
            self.filteredRecipes = allRecipes
            return
        }

        let lowercasedIngredients = selectedIngredients.map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        }

        self.filteredRecipes = allRecipes.filter { recipe in
            let recipeIngredients = recipe.ingredients.map {
                $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            }
            return lowercasedIngredients.contains { recipeIngredients.contains($0) }
        }
    }

    var selectedIngredients: [String] {
        guard let data = ingredientStorage.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([String].self, from: data) else {
            return []
        }
        return decoded
    }

    var unmatchedIngredients: [String] {
        let allRecipeIngredients = allRecipes
            .flatMap { $0.ingredients.map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() } }

        return selectedIngredients.filter { ingredient in
            !allRecipeIngredients.contains(ingredient.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())
        }
    }
}


