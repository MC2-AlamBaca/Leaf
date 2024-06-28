//
//  AllNoteView.swift
//  Leaf
//
//  Created by Marizka Ms on 26/06/24.
//

import SwiftUI
import SwiftData

//struct AllNoteView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query var notes: [Note]
//    var book: Book
//    @State private var presentCreateFolderSheet: Bool = false
//    @State private var searchText = ""
//       
//       var body: some View {
//           NavigationStack {
//                Text ("Kosong")
//                   .navigationTitle(book.title)
//                   .toolbar{
//                       ToolbarItem(placement: .topBarTrailing) {
//                           NavigationLink(destination: AddNoteView(), label: {
//                               Text("Add Notes")
//                           })
//                       }
//                   }
//                   .searchable(text: $searchText)
//        
//                   //if book already exist
//                   
//                           
//               
//           }
//       }
//}


struct AllNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var notes: [Note]
    var book: Book
    
    var body: some View {
        NavigationStack {
            RowNoteView()
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddNoteView(book: book)) {
                        Image(systemName: "plus")
                    }
                }
            }
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
//        let sampleBook = Book(title: "Atomic Habir", author:"James Clear", goals: ["Goal1","Goal2"])
//        
//        AllNoteView(book: sampleBook.title)
//    }
//}
