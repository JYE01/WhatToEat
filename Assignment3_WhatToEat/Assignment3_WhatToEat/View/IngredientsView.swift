//
//  IngredientsView.swift
//  Assignment3_WhatToEat
//
//  Created by Aranth Tjandra on 1/5/2025.
//

import SwiftUI

// Ingredients View
struct IngredientsView: View {
    @State private var ingredients: [String] = ["Pasta", "Tomatoes", "Garlic"]
    @State private var newIngredient: String = ""
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
        .background(Color.appBackground)
        .navigationTitle("Your Ingredients")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            EditButton()
                .tint(Color.appPrimaryOrange)
        }
    }

    private func addIngredient() {
        let trimmedIngredient = newIngredient.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedIngredient.isEmpty {
            ingredients.append(trimmedIngredient)
            newIngredient = ""
        }
    }

    private func removeIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
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
