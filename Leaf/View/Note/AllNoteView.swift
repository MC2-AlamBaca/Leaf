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
    
    init(book: Book) {
            self.book = book
            
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1)
                .withDesign(.serif)!
                .withSymbolicTraits(.traitBold)!,
                size: 28),
            .foregroundColor: UIColor { traitCollection in
                        switch traitCollection.userInterfaceStyle {
                        case .dark:
                            return UIColor.color2 // Warna untuk dark mode
                        case .light, .unspecified:
                            return UIColor.color1 // Warna untuk light mode
                        @unknown default:
                            return UIColor.color1 // Default fallback
                        }
                    }
        ]
        }
    
    var body: some View {
        NavigationStack {
            VStack {
                if let notes = book.notes, !notes.isEmpty {
                    NoteListView(book: book, viewModel: viewModel)
                        .responsiveBadge(goals: Array(viewModel.selectedTags)) {
                            viewModel.selectedTags.removeAll()
                        }
                }
                else {
                    Group {
                        Image("emptyStateNote")
                            .resizable()
                            .frame(width: 250, height: 250)
                        Text("Unleash your thoughts!\nAdd note to remember key points")
                            .font(.system(size: 16))
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .navigationTitle(book.title)
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
            .sheet(isPresented: $viewModel.isShowingSortFilterModal){
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
    let book = Book(title: "I Can't Talk So Smoothly", author: "John Doe", goals: ["Goal1"], isPinned: true)
    
    // Save the book first
    let context = container.mainContext
    context.insert(book)
    
    // Create and add notes to the book
    let note1 = Note(title: "Chapter 1 Summary",
                     content: "This is a summary of chapter 1. It contains important points about the introduction of the main character.",
                     lastModified: Date(),
                     prompt: "Why?",
                     tag: ["tag1","tag2"],
                     books: book, creationDate: Date())
    
    let note2 = Note(title: "Favorite Quote",
                     content: "Here's my favorite quote from page 42: 'Life is what happens when you're busy making other plans.'",
                     lastModified: Date(),
                     prompt: "Why?",
                     tag: ["tag1","tag2"],
                     books: book, creationDate: Date())
    
    context.insert(note1)
    context.insert(note2)
    
    // Ensure the book's notes array is updated
    book.notes = [note1, note2]
    
    // Return the preview
    return AllNoteView(book: book)
        .modelContainer(container)
}



