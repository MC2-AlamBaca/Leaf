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
    
    var filteredBooks: [Book] {
        if searchText.isEmpty {
            return books
        }else{
            let filteredBooks = books.compactMap { book in
                
                let titleContainsQuery = book.title.range(of: searchText, options: .caseInsensitive) != nil
              
                return titleContainsQuery ? book : nil
            }
            return filteredBooks
        }
    }
       
       var body: some View {
           NavigationStack {
                   ZStack{
                       if !books.isEmpty {
                           RowBookView(filteredBooks:filteredBooks)
                               .navigationTitle("Books")
                               .toolbar{
                                   ToolbarItem(placement: .topBarTrailing) {
                                       NavigationLink(destination: AddBookView(), label: {
                                           Text("Add Book")
                                       })
                                   }
                               }
                       }else{
                           RowBookView(filteredBooks:filteredBooks)
                               .navigationTitle("Books")
                               .toolbar{
                                   ToolbarItem(placement: .topBarTrailing) {
                                       NavigationLink(destination: AddBookView(), label: {
                                           Text("Add Book")
                                       })
                                   }
                               }
                           Text("you have no books please add some")
                    }
               }
           }
           .searchable(text: $searchText, prompt: "Search for Book")
       }
    
    
}

#Preview {
    AllBookView()
}
