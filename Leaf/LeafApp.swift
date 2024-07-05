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
//        .onAppear {
//                    NotificationCenter.default.addObserver(forName: .navigateToNote, object: nil, queue: .main) { notification in
//                        if let noteID = notification.userInfo?["noteID"] as? String,
//                           let noteUUID = UUID(uuidString: noteID),
//                           let note = modelContext.fetch(Note.self, id: noteUUID) {
//                            noteToNavigate = note
//                        }
//                    }
//                }
    }
}

