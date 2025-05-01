//
//  ContentView.swift
//  Assignment3_WhatToEat
//
//  Created by Junhui Ye on 29/4/2025.
//

import SwiftUI

// Main Content View
struct ContentView: View {
    var body: some View {
        NavigationStack {
            HomeView()
        }
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)

         ContentView()
            .preferredColorScheme(.dark)
    }
}

