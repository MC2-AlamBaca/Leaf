//
//  LeafApp.swift
//  Leaf
//
//  Created by Marizka Ms on 24/06/24.
//

import SwiftUI
import SwiftData

@main
struct LeafApp: App {
    @Environment(\.modelContext) var modelContext
    
    var body: some Scene {
        WindowGroup {
            AllBookView()
        }
        .modelContainer(for: [Book.self, Note.self])
    }
}
