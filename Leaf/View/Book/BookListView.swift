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
    
    @State private var isShowingEditView = false
    @State private var selectedBookID: UUID? // Track selected book ID for editing
    
    
    var body: some View {
        List {
            ForEach(books) { book in
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
                        selectedBookID = book.id
                        isShowingEditView = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.blue)
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        pinBook(book)
                    } label: {
                        Label("Pin", systemImage: "pin")
                    }
                    .tint(.yellow)
                }
            }
            // Navigate to EditBookView with selectedBookID when isShowingEditView is true
            .sheet(isPresented: $isShowingEditView) {
                if let selectedBookID = selectedBookID,
                   let selectedBook = books.first(where: { $0.id == selectedBookID }) {
                    AddBookView(existingBook: selectedBook)
                }
            }
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
        // Implement pinning logic
        print("Pinning book: \(book.title)")
    }
    
    private func editBook(_ book: Book) {
           // Implement your edit logic here, e.g., navigate to an edit view
           // Example: Navigate to an edit view passing `book` as a parameter
           // Replace with your navigation or edit action logic
        let editView = AddBookView(existingBook: book)
       }
}
//#Preview {
//    BookListView()
//}
