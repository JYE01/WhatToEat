// IngredientsView.swift
//
//  IngredientsView.swift
//  Assignment3_WhatToEat
//
//  Created by Aranth Tjandra on 1/5/2025.
//

import SwiftUI

enum RecipeNavigationState {
    case none
    case loading
    case showingRecipes
}

struct IngredientsView: View {
    @AppStorage("ingredientStorage") var ingredientStorage: String = ""
    @State private var ingredients: [String] = []
    @State private var newIngredient: String = ""
    @State private var recipeNavigationState: RecipeNavigationState = .none

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
                    recipeNavigationState = .loading
                }
                .foregroundColor(.appPrimaryOrange)
            }
        }
        .fullScreenCover(
            isPresented: Binding<Bool>(
                get: { recipeNavigationState == .loading || recipeNavigationState == .showingRecipes },
                set: { if !$0 { recipeNavigationState = .none } }
            )
        ) {
            switch recipeNavigationState {
            case .loading:
                RecipeLoadingView(
                    onFinishedLoading: {
                        self.recipeNavigationState = .showingRecipes
                    }
                )
            case .showingRecipes:
                RecipeView(
                    showRecipeView: Binding<Bool>(
                        get: { self.recipeNavigationState == .showingRecipes },
                        set: { if !$0 { self.recipeNavigationState = .none } }
                    )
                )
            case .none:
                EmptyView()
            }
        }
    }

    private func addIngredient() {
        let trimmedIngredient = newIngredient.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedIngredient.isEmpty {
            ingredients.append(trimmedIngredient)
            newIngredient = ""
            saveIngredients()
        }
    }

    private func removeIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
        saveIngredients()
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
