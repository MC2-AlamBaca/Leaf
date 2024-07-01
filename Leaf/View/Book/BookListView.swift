//
//  BookListView.swift
//  Leaf
//
//  Created by Marizka Ms on 30/06/24.
//

import SwiftUI
import SwiftData

struct BookListView: View {
    @Environment(\.modelContext) var modelContext
    let books: [Book]
    
    var body: some View {
        List {
            ForEach(books) { book in
                NavigationLink(destination: AllNoteView(book: book)) {
                    BookRowView(book: book)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        deleteBook(book: book)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        pinBook(book: book)
                    } label: {
                        Label("Pin", systemImage: "pin")
                    }
                    .tint(.yellow)
                }
            }
        }
    }
    
    private func deleteBook(book: Book) {
        modelContext.delete(book)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context after deleting book: \(error.localizedDescription)")
        }
    }
    
    private func pinBook(book: Book) {
        // Implement pinning logic
        print("Pinning book: \(book.title)")
    }
}
//#Preview {
//    BookListView()
//}
