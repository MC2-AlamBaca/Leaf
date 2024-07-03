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
    @StateObject var viewModel : NoteViewModel
    @State private var noteToDelete: Note? //Track book yang akan di delete
    @State private var showDeleteConfirmation: Bool = false //confimasi untuk delete
    
    var body: some View {
        List {
            ForEach(viewModel.filteredNotes(book.notes ?? [])) { note in
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
                    Button() {
//                        deleteNote(note)
                        noteToDelete = note
                        showDeleteConfirmation = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                }
            }
        }
        .alert (isPresented: $showDeleteConfirmation){
            Alert(
                title: Text("Delete Note"),
                message: Text("Are you sure you want to delete this note? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")){
                    if let noteToDelete = noteToDelete {
                        deleteNote(noteToDelete)
                    }
                },
                secondaryButton: .cancel())
        }
        .listRowSpacing(10)
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
