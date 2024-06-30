//
//  AddNoteView.swift
//  Leaf
//
//  Created by Marizka Ms on 27/06/24.
//

import SwiftUI
import SwiftData

struct AddNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var notes: [Note]
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var page: String = ""
    @State private var prompt: String = ""
    @State private var tags: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var book: Book
    
    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Enter title", text: $title)
            }
            Section(header: Text("Content")) {
                TextField("Enter content", text: $content)
            }
            Section(header: Text("Page")) {
                TextField("Enter page number", text: $page)
                    .keyboardType(.numberPad)
            }
            Section(header: Text("Prompt")) {
                TextField("Enter prompt", text: $prompt)
            }
            Section(header: Text("Tags")) {
                TextField("Enter tags, separated by commas", text: $tags)
            }
            Button(action: addNote) {
                Text("Save")
            }
        }
        .navigationTitle("Add Note")
    }
    
    private func addNote() {
        let newNote = Note(
                    title: title,
                    content: content,
                    lastModified: Date(),
                    prompt: prompt,
                    tag: tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) },
                    // Assign the current book to the note
                    books: book
                )
        modelContext.insert(newNote)
            
        if book.notes == nil {
                book.notes = [newNote]
            } else {
                book.notes?.append(newNote)
            }
            
            do {
                try modelContext.save()
                dismiss()
            } catch {
                print("Error saving note: \(error.localizedDescription)")
            }
    }
}

//#Preview {
//    AddNoteView(notes: <#T##[Note]#>, title: <#T##String#>, content: <#T##String#>, page: <#T##String#>, prompt: <#T##String#>, tags: <#T##String#>)
//}
