//
//  AllBookView.swift
//  Leaf
//
//  Created by Diky Nawa Dwi Putra on 26/06/24.
//

import SwiftUI
import SwiftData

struct AllBookView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var books: [Book]
    @State private var presentCreateFolderSheet: Bool = false
    @State private var searchText = ""
       
       var body: some View {
           NavigationStack {
                RowBookView()
                   .navigationTitle("Books")
                   .toolbar{
                       ToolbarItem(placement: .topBarTrailing) {
                           NavigationLink(destination: AddBookView(), label: {
                               Text("Add Book")
                           })
                       }
                   }
                   .searchable(text: $searchText)
        
                   //if book already exist
                   
                           
               
           }
       }
}

#Preview {
    AllBookView()
}
