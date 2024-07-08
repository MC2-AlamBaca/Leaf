//
//  SplashScreenView.swift
//  Leaf
//
//  Created by Diky Nawa Dwi Putra on 07/07/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var opacity = 0.0
        
        var body: some View {
            VStack(spacing: 20) {
                Image(.logoLeaf)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                Text("Turning Pages Into\nPermanent Memories")
                    .font(.title3)
                    .fontDesign(.serif)
                    .fontWeight(.medium)
                    .foregroundColor(.color2)
                    .multilineTextAlignment(.center)
            }
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 0.5)) {
                    opacity = 1.0
                }
            }
        }
}

#Preview {
    SplashScreenView()
}
