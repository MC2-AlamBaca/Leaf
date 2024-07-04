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
//    @State private var isEditing = false
//    @State private var editedNote: Note?
    
    
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
//                if isEditing {
//                                   TextField("Title", text: Binding(
//                                       get: { editedNote?.title ?? note.title },
//                                       set: { editedNote?.title = $0 }
//                                   ))
//                                   .font(.largeTitle)
//                                   .fontDesign(.serif)
//                                   
//                                   if let imageData = editedNote?.imageNote ?? note.imageNote, let image = UIImage(data: imageData) {
//                                       Image(uiImage: image)
//                                           .resizable()
//                                           .scaledToFit()
//                                   }
//                                   
//                                   TextField("Page", value: Binding(
//                                       get: { editedNote?.page ?? note.page },
//                                       set: { editedNote?.page = $0 }
//                                   ), formatter: NumberFormatter())
//                                   
//                                   TextEditor(text: Binding(
//                                       get: { editedNote?.content ?? note.content },
//                                       set: { editedNote?.content = $0 }
//                                   ))
//                                   
//                                   TextField("Prompt", text: Binding(
//                                       get: { editedNote?.prompt ?? note.prompt },
//                                       set: { editedNote?.prompt = $0 }
//                                   ))
//                                   
//                                   Text("Tags:")
//                                   ScrollView(.horizontal, showsIndicators: false) {
//                                       HStack {
//                                           ForEach(editedNote?.tag?.compactMap { $0 } ?? note.tag?.compactMap { $0 } ?? [], id: \.self) { tag in
//                                                                           Text(tag)
//                                                                               .padding(.horizontal, 10)
//                                                                               .padding(.vertical, 5)
//                                                                               .background(Color.blue.opacity(0.2))
//                                                                               .cornerRadius(15)
//                                                                       }
//                                       }
//                                   }
//                } else {
//                    Text(note.title)
//                        .font(.largeTitle)
//                        .fontDesign(.serif)
//                    if let imageData = note.imageNote, let image = UIImage(data: imageData) {
//                        Image(uiImage: image)
//                            .resizable()
//                            .scaledToFit()
//                    }
                    Text("Page: \(note.page ?? 0)")
                    Text(note.content)
                    Text("Last Modified: \(note.lastModified, formatter: dateFormatter)")
                    Text("Prompt: \(note.prompt)")
                    Text("Content: \(note.content)")
                Text("Creation Date: \(note.creationDate, formatter: dateFormatter)")
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
            }
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddNoteView(book: note.books!, note: note)) {
                    Text("Edit")
                }
            }
        }
        .foregroundColor(.color1)
        .padding()
        }//ScrollView
        
    }
    
//private func startEditing() {
//    editedNote = Note(
//        title: note.title,
//        imageNote: note.imageNote,
//        page: note.page,
//        content: note.content,
//        lastModified: note.lastModified,
//        prompt: note.prompt,
//        tag: note.tag,
//        books: note.books
//    )
//    isEditing = true
//}
//
//private func saveNote() {
//    guard let editedNote = editedNote else { return }
//
//    note.title = editedNote.title
//    note.imageNote = editedNote.imageNote
//    note.page = editedNote.page
//    note.content = editedNote.content
//    note.lastModified = Date() // Update the last modified date
//    note.prompt = editedNote.prompt
//    note.tag = editedNote.tag
//
//    // Save changes to the model context
//    do {
//        try note.books?.modelContext?.save()
//        isEditing = false
//    } catch {
//        print("Failed to save note: \(error.localizedDescription)")
//    }
//}
//}

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
        books: book, creationDate: Date()
    )
    
    context.insert(note)
    
    // Save the context to ensure all data is committed
    try! context.save()

    // Return the preview
    return NoteDetailView(note: note)
        .modelContainer(container)
}
