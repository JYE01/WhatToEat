//
//  ContentView.swift
//  Assignment3_WhatToEat
//
//  Created by Junhui Ye on 29/4/2025.
//

import SwiftUI

// Main Content View
struct ContentView: View {
    @StateObject var loginModel = LoginViewModel()
    
    @State private var isLaunching = true
    
    var body: some View {
        Group {
            if isLaunching {
                LaunchView()
            } else {
                NavigationStack {
                    HomeView(loginModel: loginModel)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { //after 5 seconds it will open home view
                isLaunching = false
            }
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

