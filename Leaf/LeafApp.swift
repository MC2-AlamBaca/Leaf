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

    
    var body: some Scene {
        WindowGroup {
            AllBookView()
//                .background(
//                                    NavigationLink(
//                                        destination: NoteDetailView(note: noteToNavigate),
//                                        isActive: Binding(
//                                            get: { noteToNavigate != nil },
//                                            set: { if !$0 { noteToNavigate = nil } }
//                                        )
//                                    ) {
//                                        EmptyView()
//                                    }
//                                )
        }
        .modelContainer(for: [Book.self, Note.self])
        
    }
}

