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
    @State private var bookToDelete: Book? //Track book yang akan di delete
    @State private var showDeleteConfirmation: Bool = false //confimasi untuk delete
    
    
    var body: some View {
        List {
            ForEach(sortedBooks) { book in
                NavigationLink(destination: AllNoteView(book: book)) {
                    BookRowView(book: book)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button() {
                        bookToDelete = book
                        showDeleteConfirmation = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                    
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
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Delete Book"),
                message: Text("Are you sure you want to delete this book? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")){
                    if let bookToDelete = bookToDelete {
                        deleteBook(bookToDelete)
                    }
                },
                secondaryButton: .cancel())
        }
        .listRowSpacing(10)
    }
    
    private func deleteBook(_ book: Book) {
        withAnimation {
            modelContext.delete(book)
            do {
                try modelContext.save()
            } catch {
                print("Failed to save context after deleting book: \(error.localizedDescription)")
            }
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
        selectedBook = book
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Book.self, configurations: config)
        
        // Membuat beberapa buku sampel
        let sampleBooks = [
            Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald", goals: ["Deepen your self-understanding"], isPinned: true),
            Book(title: "To Kill a Mockingbird", author: "Harper Lee", goals: ["Expand your skills and knowledge"], isPinned: false),
            Book(title: "1984", author: "George Orwell", goals: ["Overcome challenges"], isPinned: false)
        ]
        
        // Menambahkan buku sampel ke container
        for book in sampleBooks {
            container.mainContext.insert(book)
        }
        
        return BookListView(books: sampleBooks)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
