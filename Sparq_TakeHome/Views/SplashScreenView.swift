//
//  SplashScreenView.swift
//  Sparq_TakeHome
//
//  Created by Casey Millstein on 1/20/26.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var opacity = 0.0
    
    var body: some View {
        ZStack {
            if isActive {
                ContentView()
            } else {
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                    
                    Image("Pokemon_Splash")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .opacity(opacity)
                }
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.8)) {
                opacity = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                    opacity = 0.0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
