//
//  TestView.swift
//  Assignment3_WhatToEat
//
//  Created by Junhui Ye on 30/4/2025.
//

import SwiftUI

struct TestView: View {
    @ObservedObject private var firestoreManager = FirestoreManager()
    var body: some View {
        VStack {
            List {
                ForEach(firestoreManager.ingredients) { ingredient in
                    Text(ingredient.name).font(.headline)
                }
            }
        }
        .onAppear {
            firestoreManager.getIngredients()
        }
    }
}

#Preview {
    TestView()
}
