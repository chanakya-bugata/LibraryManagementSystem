//
//  ContentView.swift
//  Library Management
//
//  Created by admin12 on 22/04/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @State private var showOnboarding = false
    @State private var showLogin = false
    
    var body: some View {
        Group {
            if showSplash {
                SplashScreen()
            } else if showOnboarding {
                OnboardingView {
                    showOnboarding = false
                    showLogin = true
                }
            } else if showLogin {
                LoginView()
            }
        }
        .onAppear {
            // Simulate splash delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    showSplash = false
                    showOnboarding = true
                }
            }
        }
    }
}
