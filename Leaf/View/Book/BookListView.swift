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
    
    
    var sortedBooks: [Book] {
        books.sorted {$0.isPinned && !$1.isPinned}
    }
    
    var body: some View {
        List {
            ForEach(sortedBooks) { book in
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
                        if book.isPinned {
                            Label("Unpin", systemImage: "pin.slash")
                        } else {
                            Label("Pin", systemImage: "pin")
                        }
                    }
                    .tint(book.isPinned ? .red : .yellow)
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
        book.isPinned.toggle()
        
        //book.isPinned.toggle()
        // Save the updated book back to the context
        do {
            
            try modelContext.save()
        } catch {
            print("Failed to save context after pinning book: \(error.localizedDescription)")
        }
        // Implement pinning logic
        print("Pinning book: \(book.title)")
    }
}
//#Preview {
//    BookListView()
//}
