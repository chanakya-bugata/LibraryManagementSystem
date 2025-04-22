//
//  SplashScreen.swift
//  Library Management
//
//  Created by admin12 on 22/04/25.
//


import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            Color(hex: "#F9F2ED") // Background color
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Image("anybook_logo") // Add your logo to Assets.xcassets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                
                Text("AnyBook")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(Color(hex: "#313131"))
            }
            .opacity(isActive ? 0 : 1)
            .animation(.easeInOut(duration: 0.5), value: isActive)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isActive = true
                // Trigger navigation or change the root view here
            }
        }
    }
}
