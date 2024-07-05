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

        ScrollView() {
                VStack(alignment: .leading) {
                    
                    Text(note.title)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        .font(.title)
                        .fontDesign(.serif)
                        .bold()
                        .padding(.bottom, 4)
                    
                    Text("Last Modified: \(note.lastModified, formatter: dateFormatter)")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        .font(.footnote)
                        .padding(.horizontal, 4)
                        .padding(.bottom, 12)
                    
                    Divider()
                    
                    ZStack {
                        Text("Page \(note.page ?? 0)")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.top, 2)
                            .padding(.bottom, 20)
                            .font(.subheadline)
                            .bold()
                            .fontDesign(.serif)
                            .offset(x: -20, y:120)
                    }
                    .padding(.top, 12)
                    .padding(.horizontal)
                    
                    
                    VStack {
                        Text(note.prompt)
                            .fontDesign(.serif)
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color("Color 1"))
                            .padding(.bottom, 12)
                        
                        Text(note.content)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color("Color 2"))
                            .padding(.bottom, 16)
                        
                        if let tags = note.tag, !tags.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    Image(systemName: "tag.fill")
                                        .foregroundColor(Color("Color 2"))
                                        
                                    ForEach(tags.compactMap { $0 }, id: \.self) { tag in
                                        Text(tag)
                                            .cornerRadius(15)
                                            .foregroundColor(Color("Color 2"))
                                            .bold()
                                            .fontDesign(.serif)
                                            .font(.subheadline)
                                    }
                                }

                            }
                        }
                    }
                    .padding()
//                    .border("Color 6", width: 5)
//                    .background(Color("Color 6"))
//                    .cornerRadius(10)
//                    .padding(.top, 1)
                   
                    
                   
                    
                   
                    
                }
                //            Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)// tipe navbartype
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddNoteView(book: note.books!, note: note)) {
                        Text("Edit")
                    }
                }
            }
            .foregroundColor(.color1)
            .padding()
        }
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
