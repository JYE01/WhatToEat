// IngredientsView.swift
//
//  IngredientsView.swift
//  Assignment3_WhatToEat
//
//  Created by Felix on 1/5/2025.
//

import SwiftUI

// The main view that allows users to add ingredients and navigate to filtered recipes
struct IngredientsView: View {
    @StateObject private var viewModel = IngredientsViewModel() // ViewModel manages all logic and data

    var body: some View {
        NavigationStack {
            VStack {
                // List of current ingredients added by the user
                List {
                    ForEach(viewModel.ingredients, id: \.self) { ingredient in
                        Text(ingredient)
                            .foregroundColor(Color.appText) // Custom color for app theme
                    }
                    .onDelete(perform: viewModel.removeIngredient) // Swipe to delete functionality
                }
                .listStyle(.plain) // Use a plain list style for cleaner appearance

                // Input field and button to add new ingredients
                HStack {
                    // Text field for user to type a new ingredient
                    TextField("Add ingredient...", text: $viewModel.newIngredient)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit { viewModel.addIngredient() } // Add ingredient on return key
                        .submitLabel(.done)

                    // Plus button to trigger addIngredient function
                    Button(action: { viewModel.addIngredient() }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.appPrimaryOrange)
                    }
                    .disabled(viewModel.newIngredient.trimmingCharacters(in: .whitespaces).isEmpty) // Disable button if input is empty
                }
                .padding()

                // Navigation to RecipeView triggered programmatically
                NavigationLink(destination: RecipeView(), isActive: $viewModel.navigateToRecipes) {
                    EmptyView() // Invisible link triggered by state
                }
            }
            .background(Color.appBackground) // App-themed background
            .navigationTitle("Your Ingredients")
            .navigationBarTitleDisplayMode(.inline)

            // Toolbar with "Go" button to start loading and view recipes
            .toolbar {
                if !viewModel.ingredients.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { viewModel.startLoadingSequence() }) {
                            Text("Go")
                                .foregroundColor(.appPrimaryOrange)
                        }
                    }
                }
            }

            // Fullscreen loading screen overlay (not in nav stack)
            .fullScreenCover(isPresented: $viewModel.showLoading) {
                RecipeLoadingView {
                    viewModel.finishLoadingSequence() // Called after loading completes
                }
            }
        }
    }
}

// Previews in both light and dark modes
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
