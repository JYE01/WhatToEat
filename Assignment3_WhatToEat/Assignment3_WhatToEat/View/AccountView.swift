//
//  AccountView.swift
//  Assignment3_WhatToEat
//
//  Created by Junhui Ye on 3/5/2025.
//

import SwiftUI

struct AccountView: View {
    @ObservedObject var loginModel: LoginViewModel
    @ObservedObject private var firestoreManager = FirestoreManager()
    @AppStorage("currentUser") var currentUser: Data?
    @Environment(\.dismiss) var dismiss

    @State private var favoriteRecipes: [Recipe] = []
    @State private var newPassword: String = ""
    
    var user: User? {
        guard let currentUser = currentUser,
              let user = try? JSONDecoder().decode(User.self, from: currentUser) else {
            return nil
        }
        return user
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let user = user {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack { //This part will display the user name
                            Image(systemName: "person.fill")
                                .foregroundColor(.appPrimaryOrange)
                            Text(user.name)
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        HStack { //This part will display the user email
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.appPrimaryOrange)
                            Text(user.email)
                                .font(.body)
                                .foregroundColor(.appMutedText)
                        }
                        HStack { //this part will display password change section
                            SecureField("New Password", text: $newPassword)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)

                            Button("Change Password") {
                                loginModel.updatePassword(newPassword: newPassword)
                            }
                            .font(.subheadline) //this will make button smaller then headline
                            .padding()
                            .background(Color.appPrimaryOrange)
                            .foregroundColor(.white)
                            .cornerRadius(10)

                            if let message = loginModel.passwordMessage {
                                Text(message)
                                    .foregroundColor(message.contains("success") ? .green : .red)
                                    .padding(.top, 10)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.appLightOrange.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Divider().padding(.horizontal)

                    Text("Favorite Recipes")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.appPrimaryOrange)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top)

                    if favoriteRecipes.isEmpty {
                         Text("You haven't favorited any recipes yet.")
                             .foregroundColor(.appMutedText)
                             .padding()
                             .frame(maxWidth: .infinity)
                    } else {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                            ForEach(favoriteRecipes) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipe: recipe)) { // this will navigate to recipe detail view fore each recipe card
                                    FavoriteRecipeCardView(recipe: recipe)
                                }
                            }
                        }
                        .padding(.horizontal)

                    }

                    Spacer()

                    Button("Logout") {
                        loginModel.reset()
                        currentUser = nil
                        dismiss()
                    }
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .frame(maxWidth: 200)
                    .background(Color.appPrimaryOrange)
                    .clipShape(Capsule())
                    .shadow(color: Color.appPrimaryOrange.opacity(0.4), radius: 5, x: 0, y: 3)
                    .padding(.top, 30)
                    .padding(.bottom)

                } else {
                    VStack {
                        Spacer()
                        Image(systemName: "person.crop.circle.badge.exclamationmark")
                            .font(.system(size: 60))
                            .foregroundColor(.appMutedText)
                        Text("No user data available.")
                            .font(.title3)
                            .foregroundColor(.appMutedText)
                            .padding(.top)
                        Text("Please login or create an account.")
                             .font(.subheadline)
                             .foregroundColor(.appMutedText)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                }
            }
        }
        .background(Color.appBackground.edgesIgnoringSafeArea(.all))
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let email = user?.email {
                firestoreManager.fetchFavouriteRecipes(forEmail: email) { fetchedRecipes in
                    DispatchQueue.main.async {
                        self.favoriteRecipes = fetchedRecipes
                    }
                }
            }
        }
    }
}

struct FavoriteRecipeCardView: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading) {
            Image(recipe.image) // Use the name stored in the `image` field
                .resizable()
                .scaledToFill()
                .frame(height: 100)
                .clipped()

            Text(recipe.name)
                .font(.headline)
                .lineLimit(2)
                .foregroundColor(Color.appText)
                .padding([.horizontal, .bottom], 8)
                .padding(.top, 4)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
        }
        .background(Color.appBackground)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
    }

}

#Preview {
    AccountView(loginModel: LoginViewModel())
}
