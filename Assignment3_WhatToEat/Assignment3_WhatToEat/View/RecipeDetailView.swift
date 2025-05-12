//
//  RecipeDetailView.swift
//  Assignment3_WhatToEat
//
//  Created by Felix on 4/5/2025.
//

import SwiftUI

struct RecipeDetailView: View {
    // Tracks whether this recipe is favorited by the user
    @State private var isFavourite = false

    // Retrieves the current logged-in user's data from AppStorage (used for favouriting)
    @AppStorage("currentUser") var currentUser: Data?

    // Firestore manager handles reading/writing favourite status in Firestore
    @ObservedObject var firestoreManager = FirestoreManager()
    
    // The recipe to display
    let recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // --- Recipe Image ---
                Image(recipe.image)
                    .resizable()
                    .aspectRatio(16/9, contentMode: .fill) // Keeps image proportion consistent
                    .frame(maxWidth: .infinity) // Makes image expand across the screen width
                    .frame(height: 180)
                    .clipped() // Trims anything beyond the bounds
                    .cornerRadius(10)

                // --- Recipe Title ---
                Text(recipe.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // --- Cuisine Label + Favourite Button ---
                HStack {
                    Text("Cuisine: \(recipe.cuisine)")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Spacer()

                    // Heart icon toggles favourite state
                    if let data = currentUser,
                       let user = try? JSONDecoder().decode(User.self, from: data),
                       let recipeID = recipe.id { // this will check if the current user is not nil, is decoadable data, and correct recipe ID
                        Button(action: {
                            if isFavourite {
                                // If currently favourited, remove from favourites in Firestore
                                firestoreManager.removeFavourite(forUserEmail: user.email, recipeID: recipeID) { success in
                                    if success {
                                        isFavourite = false
                                    } else {
                                        print("Failed to remove from favourites")
                                    }
                                }
                            } else {
                                // Otherwise, add to favourites
                                firestoreManager.addFavourite(forUserEmail: user.email, recipeID: recipeID) { success in
                                    if success {
                                        isFavourite = true
                                    } else {
                                        print("Failed to add to favourites")
                                    }
                                }
                            }
                        }) {
                            // This will display filled or unfilled heart based on isFavourite state
                            Image(systemName: isFavourite ? "heart.fill" : "heart")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.red)
                        }
                    }

                }

                // --- Ingredients Section ---
                Text("Ingredients")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(recipe.ingredients.joined(separator: ", "))
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true) // Allows line wrapping

                Divider()

                // --- Description Section ---
                Text("Description")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(recipe.description)
                    .font(.body)

                Spacer()
            }
            .padding()
        }

        // --- On Appear: Check if this recipe is already favourited by current user ---
        .onAppear {
            guard let data = currentUser,
                  let user = try? JSONDecoder().decode(User.self, from: data),
                  let recipeID = recipe.id else {
                print("Invalid user data or recipe ID on appear")
                return
            }

            // Query Firestore to determine if this recipe is already in favourites
            firestoreManager.isFavourite(forEmail: user.email, recipeID: recipeID) { fav in
                isFavourite = fav
            }
        }

        // --- Navigation Bar Setup ---
        .navigationTitle("Recipe Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// --- Preview with a sample recipe for design testing ---
struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRecipe = Recipe(
            name: "Spaghetti Bolognese",
            cuisine: "Italian",
            ingredients: ["Spaghetti", "Ground Beef", "Tomato Sauce", "Onion", "Garlic", "Olive Oil", "Salt", "Pepper"],
            description: "A classic Italian pasta dish made with a rich, meaty tomato sauce served over spaghetti noodles.",
            image: "" // Replace with valid image name in Assets for visual testing
        )

        NavigationView {
            RecipeDetailView(recipe: sampleRecipe)
        }
    }
}
