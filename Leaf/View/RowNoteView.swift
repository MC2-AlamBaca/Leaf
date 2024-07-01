//
//  RowNoteView.swift
//  Leaf
//
//  Created by Marizka Ms on 27/06/24.
//

import SwiftUI
import SwiftData

struct RowNoteView: View {
    @Environment(\.modelContext) var modelContext
    
    // Use @Query to fetch all Note objects
    @Query var notes: [Note]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(notes) { note in
                    NavigationLink(destination: NoteDetailView(note: note)) {
                        VStack(alignment: .leading) {
                            Text(note.title)
                                .font(.headline)
                            Text(note.content)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(5)
                        }
                        Spacer()
                        Text("\(note.lastModified)")
                            .foregroundColor(.secondary)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            deleteNote(note: note)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            pinNote(note: note)
                        } label: {
                            Label("Pin", systemImage: "pin")
                        }
                        .tint(.yellow)
                    }
                }
            }
        }
    }
    
    func deleteNote(note: Note) {
        modelContext.delete(note)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context after deleting note: \(error.localizedDescription)")
        }
    }
    
    func pinNote(note: Note) {
       //pin logic
        print("Pinning note: \(note.title)")
    }
}

//#Preview {
//    RowNoteView()
//}
