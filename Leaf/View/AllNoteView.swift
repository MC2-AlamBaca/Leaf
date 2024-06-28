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
    @State private var searchText = ""
    var book: Book
    
    var body: some View {
        NavigationStack {
            ZStack {
                if let notes = book.notes, !notes.isEmpty {
                    List {
                        ForEach(filteredNotes) { note in
                            NavigationLink(destination: NoteDetailView(note: note)) {
                                VStack(alignment: .leading) {
                                    Text(note.title)
                                        .font(.headline)
                                    Text(note.content.prefix(50) + "...")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .onDelete(perform: deleteNotes)
                    }
                } else {
                    Text("You have no notes for this book. Please add some.")
                }
            }
            .navigationTitle(book.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: AddNoteView(book: book)) {
                        Text("Add Note")
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search notes")
        }
    }
    
    private var filteredNotes: [Note] {
        guard let notes = book.notes else { return [] }
        if searchText.isEmpty {
            return notes
        } else {
            return notes.filter { note in
                note.title.localizedCaseInsensitiveContains(searchText) ||
                note.content.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func deleteNotes(at offsets: IndexSet) {
        guard var notes = book.notes else { return }
        for index in offsets {
            let note = notes[index]
            modelContext.delete(note)
            notes.remove(at: index)
        }
        book.notes = notes
        do {
            try modelContext.save()
        } catch {
            print("Error deleting note: \(error.localizedDescription)")
        }
    }
}

struct NoteDetailView: View {
    var note: Note
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(note.title)
                .font(.largeTitle)
            if let imageData = note.imageNote, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
            Text("Page: \(note.page ?? 0)")
            Text(note.content)
            Text("Last Modified: \(note.lastModified, formatter: dateFormatter)")
            Text("Prompt: \(note.prompt)")
            Text("Tags: \(note.tag?.compactMap { $0 }.joined(separator: ", ") ?? "No Tags")")
            Spacer()
        }
        .padding()
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()


//struct AllNoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        var book = Book
//        AllNoteView(book: book)
//    }
//}
