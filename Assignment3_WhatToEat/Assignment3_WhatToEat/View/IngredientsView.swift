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
    @StateObject private var viewModel = IngredientsViewModel() // ViewModel manages logic and state

    var body: some View {
        NavigationStack {
            VStack {
                // --- Ingredients List ---
                List {
                    ForEach(viewModel.ingredients, id: \.self) { ingredient in
                        Text(ingredient)
                            .foregroundColor(Color.appText)
                    }
                    .onDelete(perform: viewModel.removeIngredient)
                }
                .listStyle(.plain)

                // --- Add Ingredient Input Field and Button ---
                HStack {
                    TextField("Add ingredient...", text: $viewModel.newIngredient)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit { viewModel.addIngredient() }
                        .submitLabel(.done)

                    Button(action: { viewModel.addIngredient() }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.appPrimaryOrange)
                    }
                    .disabled(viewModel.newIngredient.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()

                // --- Navigation Trigger to RecipeView ---
                NavigationLink(
                    isActive: $viewModel.navigateToRecipes,
                    destination: {
                        if let recipeVM = viewModel.recipeViewModel {
                            RecipeView(recipeViewModel: recipeVM)
                        } else {
                            EmptyView()
                        }
                    },
                    label: {
                        EmptyView()
                    }
                )
                
            }
            .background(Color.appBackground)
            .navigationTitle("Your Ingredients")
            .navigationBarTitleDisplayMode(.inline)

            // --- Toolbar with "Go" button to start loading and fetch recipes ---
            .toolbar {
                if !viewModel.ingredients.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.startLoadingSequence()
                        }) {
                            Text("Go")
                                .foregroundColor(.appPrimaryOrange)
                        }
                    }
                }
            }

            // --- Fullscreen loading screen shown while fetching recipes ---
            .fullScreenCover(isPresented: $viewModel.showLoading) {
                RecipeLoadingView {
                    viewModel.finishLoadingSequence()
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
