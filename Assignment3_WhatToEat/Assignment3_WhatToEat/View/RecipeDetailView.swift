//
//  RecipeDetailView.swift
//  Assignment3_WhatToEat
//
//  Created by Felix on 4/5/2025.
//

import SwiftUI

struct RecipeDetailView: View {
    @State private var isFavourite = false
    @AppStorage("userEmail") var userEmail: String = "" //app storage to store user email
    @ObservedObject var firestoreManager = FirestoreManager()
    
    let recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                //Image
                if let uiImage = UIImage(named: recipe.image), !recipe.image.isEmpty {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .clipped()
                        .cornerRadius(10)
                } else { //handle empty image
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 180)
                        .cornerRadius(10)
                        .overlay(
                            Text("No Image")
                                .foregroundColor(.gray)
                        )
                }

                // Name
                Text(recipe.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                //Cuisine & Favourites
                HStack {
                    Text("Cuisine: \(recipe.cuisine)")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Spacer()

                    Button(action: {
                        if let recipeID = recipe.id {
                            firestoreManager.fetchUser(byEmail: userEmail) { user in
//                                if let user = user, let userID = user.id {
//                                    if isFavourite {
//                                        firestoreManager.removeFavourite(forUserID: userID, recipeID: recipeID) { success in
//                                            if success {
//                                                isFavourite = false
//                                            } else {
//                                                print("Failed to remove from favourites")
//                                            }
//                                        }
//                                    } else {
//                                        firestoreManager.addFavourite(forUserID: userID, recipeID: recipeID) { success in
//                                            if success {
//                                                isFavourite = true
//                                            } else {
//                                                print("Failed to add to favourites")
//                                            }
//                                        }
//                                    }
//                                } else {
//                                    print("User not found or userID is nil")
//                                }
                            }
                        } else {
                            print("recipe id is nil")
                        }
                    }) {
                        Image(systemName: isFavourite ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.red)
                    }
                }
                
                // Ingredients
                Text("Ingredients")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(recipe.ingredients.joined(separator: ", "))
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)

                Divider()

                // Description
                Text("Description")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(recipe.description)
                    .font(.body)
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
//            if let recipeID = recipe.id {
//                firestoreManager.fetchUser(byEmail: userEmail) { user in
//                    if let user = user, let userID = user.id {
//                        firestoreManager.FavouriteRecipe(byUserID: userID, recipeID: recipeID) { fav in
//                            isFavourite = fav
//                        }
//                    } else {
//                        print("User not found or userID is nil")
//                    }
//                }
//            } else {
//                print("recipe.id is nil")
//            }
        }
        .navigationTitle("Recipe Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRecipe = Recipe(
            name: "Spaghetti Bolognese",
            cuisine: "Italian",
            ingredients: ["Spaghetti", "Ground Beef", "Tomato Sauce", "Onion", "Garlic", "Olive Oil", "Salt", "Pepper"],
            description: "A classic Italian pasta dish made with a rich, meaty tomato sauce served over spaghetti noodles.",
            image: ""
        )

        NavigationView {
            RecipeDetailView(recipe: sampleRecipe)
        }
    }
}
