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

    @State private var selectedBook: Book? // Track selected book for editing
    
    
    var body: some View {
        List {
            ForEach(sortedBooks) { book in
                NavigationLink(destination: AllNoteView(book: book)) {
                    BookRowView(book: book)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        deleteBook(book)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    Button() {
                        // Set selectedBookID and show edit view
                        editBook(book)
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.blue)
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        pinBook(book)
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
        }.sheet(item: $selectedBook) { book in
            AddBookView(existingBook: book)
        }
    }
    
    private func deleteBook(_ book: Book) {
        modelContext.delete(book)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context after deleting book: \(error.localizedDescription)")
        }
    }

    private func pinBook(_ book: Book) {
        book.isPinned.toggle()
        
        // Save the updated book back to the context
        do {
            
            try modelContext.save()
        } catch {
            print("Failed to save context after pinning book: \(error.localizedDescription)")
        }
    
        // Implement pinning logic
        print("Pinning book: \(book.title)")
    }
    
    private func editBook(_ book: Book) {
//        selectedBookID = book.id
//        DispatchQueue.main.async {
//            isShowingEditView = true
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                   isShowingEditView = true
//               }
        selectedBook = book
    }
}
//#Preview {
//    BookListView()
//}
