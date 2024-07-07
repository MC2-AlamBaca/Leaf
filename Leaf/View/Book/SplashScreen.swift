//
//  SplashScreen.swift
//  Leaf
//
//  Created by Diky Nawa Dwi Putra on 07/07/24.
//

import SwiftUI

struct SplashScreen: View {
    @State private var opacity = 0.0
    
    var body: some View {
        VStack(spacing: 20) {
            Image(.logoLeaf)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            
            Text("Turning Pages Into Permanent Memories")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeIn(duration: 1.0)) {
                opacity = 1.0
            }
        }
    }
}

#Preview {
    SplashScreen()
}
