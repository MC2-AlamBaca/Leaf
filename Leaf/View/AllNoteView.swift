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
    @Query var notes: [Note]
     var book: Book
    @State private var presentCreateFolderSheet: Bool = false
    @State private var searchText = ""
       
       var body: some View {
           NavigationStack {
                Text ("Kosong")
                   .navigationTitle(book.title)
                   .toolbar{
                       ToolbarItem(placement: .topBarTrailing) {
                           NavigationLink(destination: AddBookView(), label: {
                               Text("Add Notes")
                           })
                       }
                   }
                   .searchable(text: $searchText)
        
                   //if book already exist
                   
                           
               
           }
       }
}

//#Preview {
//    AllNoteView()
//}
