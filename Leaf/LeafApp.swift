//
//  LeafApp.swift
//  Leaf
//
//  Created by Marizka Ms on 24/06/24.
//

import SwiftUI
import SwiftData
import UserNotifications


@main
struct LeafApp: App {
    
    @Environment(\.modelContext) var modelContext
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showSplashScreen = true

    
    var body: some Scene {
        WindowGroup {
            if showSplashScreen {
                SplashScreen()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                showSplashScreen = false
                            }
                        }
                    }
            } else {
                AllBookView()
            }
        }
        .modelContainer(for: [Book.self, Note.self])
        
    }
}

