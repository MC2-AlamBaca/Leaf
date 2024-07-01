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
            .navigationTitle(book.title).fontDesign(.serif)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: AddNoteView(book: book)) {
                        Text("Add Note")
                            .fontDesign(.serif)
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


//struct AllNoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        var book = Book
//        AllNoteView(book: book)
//    }
//}
