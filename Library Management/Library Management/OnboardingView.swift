//
//  OnboardingView.swift
//  Library Management
//
//  Created by admin12 on 22/04/25.
//

import SwiftUI


struct OnboardingView: View {
    var onDone: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to AnyBook 📚")
                .font(.title)
                .padding()

            Text("Manage your library, track books, and explore with ease.")
                .multilineTextAlignment(.center)
                .padding()

            Button("Get Started") {
                onDone()
            }
            .padding()
            .background(Color(hex: "#313131"))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
