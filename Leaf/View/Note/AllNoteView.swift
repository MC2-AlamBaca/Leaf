//
//  AllNoteView.swift
//  Leaf
//
//  Created by Marizka Ms on 26/06/24.
//

import SwiftUI
import SwiftData


struct AllNoteView: View {
    @Environment(\.modelContext) private var modelContext
    var book: Book
    @StateObject private var viewModel = NoteViewModel()
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                if let notes = book.notes, !notes.isEmpty {
                    NoteListView(book: book, viewModel: viewModel)
                }
                else {
                    NoteListView(book: book, viewModel: viewModel)
                }
            }
            .navigationTitle(book.title)
            .navigationBarBackButtonHidden(true) // Hide default back button
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.isShowingSortFilterModal = true
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(.color2)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddNoteView(book: book)) {
                        Image(systemName: "plus")
                            .foregroundColor(.color2)
                    }
                }
            }
            
            .searchable(text: $viewModel.searchText, prompt: "Search for Note")
            .foregroundColor(.color2)
            
            .navigationBarItems(leading:
                                Button(action: {
                                    dismiss() // Dismiss action for custom "Back" button
                                }) {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.color2) // Customize back button color
                                        .imageScale(.large)
                                    Text("Books")
                                        .foregroundColor(.color2)
                                }
                            )
            
            .sheet(isPresented: $viewModel.isShowingSortFilterModal){
                //SortFilterNoteModalView(viewModel: viewModel, allTags: Array(Set(book.notes.flatMap { $0.tag })))
                SortFilterNoteModalView(viewModel: viewModel, allTags: getAllTags())
                    .foregroundColor(.color2)
            }
        }
    }
    
    private func getAllTags() -> [String] {
            let allTags = book.notes?.compactMap { $0.tag }.flatMap { $0 } ?? []
            return Array(Set(allTags.compactMap { $0 }))
        }
    }




private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    // Create a mock ModelContainer
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Book.self, Note.self, configurations: config)
    
    // Create a sample book with notes
    let book = Book(title: "Sample Book", author: "John Doe", goals: ["Goal1"], isPinned: true)
    
    // Save the book first
    let context = container.mainContext
    context.insert(book)
    
    // Create and add notes to the book
    let note1 = Note(title: "Chapter 1 Summary",
                     content: "This is a summary of chapter 1. It contains important points about the introduction of the main character.",
                     lastModified: Date(),
                     prompt: "Why?",
                     tag: ["tag1","tag2"],
                     books: book)
    
    let note2 = Note(title: "Favorite Quote",
                     content: "Here's my favorite quote from page 42: 'Life is what happens when you're busy making other plans.'",
                     lastModified: Date(),
                     prompt: "Why?",
                     tag: ["tag1","tag2"],
                     books: book)
    
    context.insert(note1)
    context.insert(note2)
    
    // Ensure the book's notes array is updated
    book.notes = [note1, note2]
    
    // Return the preview
    return AllNoteView(book: book)
        .modelContainer(container)
}



