//
//  SplashView.swift
//  UMLite
//
//  Created by Rajeev Kalangi on 17/08/25.
//
import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var animate = false
    
    var body: some View {
        if isActive {
            ContentView() // Your actual app content
        } else {
            VStack {
                Image("UMLIcon") // Replace with your actual asset name
                    .resizable()
                    .frame(width: 240, height: 240)
                    .cornerRadius(32)
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .scaleEffect(animate ? 1 : 0.5)
                    .animation(.easeOut(duration: 1), value: animate)
                    .onAppear {
                        animate = true
                        if UIImage(named: "UMLIcon") == nil {
                            print("⚠️ UMLIcon not found in asset catalog")
                        }
                    }
                Text("Plant-UML")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 8)
                Text("Design. Preview. Iterate.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
