//
//  NoteDetailView.swift
//  Leaf
//
//  Created by Marizka Ms on 01/07/24.
//

import SwiftUI
import SwiftData

struct NoteDetailView: View {
    var note: Note
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                Text(note.title)
                    .font(.largeTitle)
                    .fontDesign(.serif)
                if let imageData = note.imageNote, let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
                Text("Page: \(note.page ?? 0)")
                Text(note.content)
                Text("Last Modified: \(note.lastModified, formatter: dateFormatter)")
                Text("Prompt: \(note.prompt)")
                Text("Content: \(note.content)")
                if let tags = note.tag, !tags.isEmpty {
                    Text("Tags:")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(tags.compactMap { $0 }, id: \.self) { tag in
                                Text(tag)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(15)
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }//ScrollView
        
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

    // Create a sample book
    let book = Book(title: "Sample Book", author: "John Doe", goals: ["Goal1"], isPinned: true)
    
    // Save the book first
    let context = container.mainContext
    context.insert(book)
    
    // Create a sample image (optional)
    let sampleImage = UIImage(systemName: "book.fill")
    let imageData = sampleImage?.pngData()
    
    // Create a sample note
    let note = Note(
        title: "Chapter 1 Summary",
        imageNote: imageData,
        page: 20,
        content: "This is a summary of chapter 1. It contains important points about the introduction of the main character. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        lastModified: Date(),
        prompt: "Summarize the key points of Chapter 1",
        tag: ["Chapter1", "Summary", "Introduction"],
        books: book
    )
    
    context.insert(note)
    
    // Save the context to ensure all data is committed
    try! context.save()

    // Return the preview
    return NoteDetailView(note: note)
        .modelContainer(container)
}
