//
//  IngredientsView.swift
//  Assignment3_WhatToEat
//
//  Created by Aranth Tjandra on 1/5/2025.
//

import SwiftUI

// Ingredients View
struct IngredientsView: View {
    @AppStorage("ingredientStorage") var ingredientStorage: String = "" //app storage to temporarily store the ingredients
    @State private var ingredients: [String] = []
    @State private var newIngredient: String = ""
    @State private var showLoading = false
    @State private var showRecipes = false

    var body: some View {
        VStack {
            List {
                ForEach(ingredients, id: \.self) { ingredient in
                    Text(ingredient)
                        .foregroundColor(Color.appText)
                }
                .onDelete(perform: removeIngredient)
            }
            .listStyle(.plain)

            HStack {
                TextField("Add ingredient...", text: $newIngredient)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit(addIngredient)
                    .submitLabel(.done)

                Button(action: addIngredient) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.appPrimaryOrange)
                }
                .disabled(newIngredient.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding()
        }
        .onAppear(perform: loadIngredients)
        .background(Color.appBackground)
        .navigationTitle("Your Ingredients")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Go") {
                    showLoading = true
                }
                .foregroundColor(.appPrimaryOrange)
                .fullScreenCover(isPresented: $showLoading) {
                    RecipeLoadingView(showLoading: $showLoading, showRecipeView: $showRecipes)
                }
                .fullScreenCover(isPresented: $showRecipes) {
                    RecipeView(showRecipeView: $showRecipes)
                }
            }
        }
    }

    private func addIngredient() {
        let trimmedIngredient = newIngredient.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedIngredient.isEmpty {
            ingredients.append(trimmedIngredient)
            newIngredient = ""
            saveIngredients() //save to app storage after add
        }
    }

    private func removeIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
        saveIngredients() //save to app storage after remove
    }
    
    private func saveIngredients() {
        if let data = try? JSONEncoder().encode(ingredients),
            let json = String(data: data, encoding: .utf8) {
            ingredientStorage = json
        }
    }

    private func loadIngredients() {
        if let data = ingredientStorage.data(using: .utf8),
            let decoded = try? JSONDecoder().decode([String].self, from: data) {
            ingredients = decoded
        }
    }
}

// Preview
struct IngredientsView_Previews: PreviewProvider {
     static var previews: some View {
         NavigationStack {
              IngredientsView()
         }
         .preferredColorScheme(.light)

         NavigationStack {
              IngredientsView()
         }
         .preferredColorScheme(.dark)
     }
}
