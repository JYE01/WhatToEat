//
//  HomeView.swift
//  Assignment3_WhatToEat
//
//  Created by Aranth Tjandra on 1/5/2025.
//

import SwiftUI

// Home View
struct HomeView: View {
    @ObservedObject var loginModel: LoginViewModel
    
    @State private var isButtonScaled = false
    @State private var accountOrLogin = false

    var body: some View {

        VStack(spacing: 40) {

            Spacer()

            Image("1")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .shadow(color: .gray.opacity(0.4), radius: 10, x: 0, y: 5)

            Text("Recipe Finder")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.appPrimaryOrange) //

            Text("Enter your ingredients and discover delicious recipes!")
                .font(.headline)
                .foregroundColor(.appMutedText) //
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

            NavigationLink(destination: IngredientsView()) { //
                Text("Find Recipes")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 40)
                    .background(Color.appPrimaryOrange) //
                    .clipShape(Capsule())
                    .shadow(color: Color.appPrimaryOrange.opacity(0.5), radius: 8, x: 0, y: 4) //
                    .scaleEffect(isButtonScaled ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 0.15), value: isButtonScaled)
                    .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                        isButtonScaled = pressing
                    }, perform: {})
            }
            .padding(.bottom, 50)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    DispatchQueue.main.async {
                        accountOrLogin = true
                    }
                }) {
                    Image(systemName: "person.crop.circle")
                        .font(.title2)
                        .foregroundColor(.appPrimaryOrange)
                }
            }
        }
        NavigationLink(
            destination: loginModel.canLogin
                ? AnyView(AccountView(loginModel: loginModel)) // display account if logged in
                : AnyView(LoginView(loginModel: loginModel)),
            isActive: $accountOrLogin
        ) {
            EmptyView()
        }
    }
}

// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { // Use NavigationStack for preview consistency
            HomeView(loginModel: LoginViewModel())
        }
        .preferredColorScheme(.light)

        NavigationStack { // Use NavigationStack for preview consistency
            HomeView(loginModel: LoginViewModel())
        }
        .preferredColorScheme(.dark)
    }
}
