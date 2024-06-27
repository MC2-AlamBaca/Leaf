//
//  tesdulubro.swift
//  Leaf
//
//  Created by Diky Nawa Dwi Putra on 27/06/24.
//

import SwiftUI
import SwiftData

struct tesdulubro: View {
    
    @State private var books: [Book] = [] // Assuming books is managed by @State or @ObservedObject
    
    @State private var presentCreateFolderSheet: Bool = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                if !filteredBooks().isEmpty {
                    List(filteredBooks()) { book in
                        //RowBookView(book: book)
                    }
                    .navigationTitle("Books")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                presentCreateFolderSheet = true
                            }) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                } else {
                    VStack {
                        Text("You have no books, please add some.")
                        NavigationLink(destination: AddBookView(), label: {
                            Text("Add Book")
                        })
                    }
                    .navigationTitle("Books")
                }
            }
            .sheet(isPresented: $presentCreateFolderSheet) {
                AddBookView()
            }
        }
        .searchable(text: $searchText)
    }
    
    private func filteredBooks() -> [Book] {
        if searchText.isEmpty {
            return books
        } else {
            return books.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
#Preview {
    tesdulubro()
}
