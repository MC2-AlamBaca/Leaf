//
//  NoteListView.swift
//  Leaf
//
//  Created by Marizka Ms on 27/06/24.
//

import SwiftUI
import SwiftData

struct NoteListView: View {
    @Environment(\.modelContext) private var modelContext
    var book: Book
    @StateObject private var viewModel = NoteViewModel()
    @Query private var notes: [Note]
    
//    init(books: Book) {
//        self.book = books
//        self._notes = Query(filter: #Predicate { note in
//            note.books?.id == book.id
//        })
//    }
    
    var body: some View {
        List {
            ForEach(sortedAndFilteredNotes) { note in
                NavigationLink(destination: NoteDetailView(note: note)) {
                    NoteRowView(note: note)
                }
                .swipeActions(edge: .leading) {
                    Button {
                        togglePinNote(note)
                    } label: {
                        Label(note.isPinned ? "Unpin" : "Pin", systemImage: note.isPinned ? "pin.slash" : "pin")
                    }
                    .tint(.yellow)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        deleteNote(note)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }
    
    private var sortedAndFilteredNotes: [Note] {
        notes
            .filter { note in
                viewModel.searchText.isEmpty ||
                note.title.localizedCaseInsensitiveContains(viewModel.searchText) ||
                note.content.localizedCaseInsensitiveContains(viewModel.searchText)
            }
            .sorted { note1, note2 in
                if note1.isPinned != note2.isPinned {
                    return note1.isPinned && !note2.isPinned
                }
                return note1.lastModified > note2.lastModified
            }
    }
    
    private func togglePinNote(_ note: Note) {
        note.isPinned.toggle()
        note.lastModified = Date()
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context after pinning note: \(error.localizedDescription)")
        }
    }
    
    private func deleteNote(_ note: Note) {
        modelContext.delete(note)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context after deleting note: \(error.localizedDescription)")
        }
    }
}
//#Preview {
//    // Create a mock ModelContainer
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: Book.self, Note.self, configurations: config)
//
//    // Create a sample book
//    let book = Book(title: "Sample Book", author: "John Doe", goals: ["Goal1"], isPinned: true)
//    
//    // Save the book first
//    let context = container.mainContext
//    context.insert(book)
//    
//    // Create a sample image (optional)
//    let sampleImage = UIImage(systemName: "book.fill")
//    let imageData = sampleImage?.pngData()
//    
//    // Create a sample note
//    let note = Note(
//        title: "Chapter 1 Summary",
//        imageNote: imageData,
//        page: 20,
//        content: "This is a summary of chapter 1. It contains important points about the introduction of the main character. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
//        lastModified: Date(),
//        prompt: "Summarize the key points of Chapter 1",
//        tag: ["Chapter1", "Summary", "Introduction"],
//        books: book
//    )
//    
//    context.insert(note)
//    
//    // Save the context to ensure all data is committed
//    try! context.save()
//
//    // Return the preview
//    return NoteDetailView(note: note)
//        .modelContainer(container)
//}
