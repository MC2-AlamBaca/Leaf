////
////  BookView.swift
////  Leaf
////
////  Created by Diky Nawa Dwi Putra on 27/06/24.
////
//
//import SwiftUI
//import SwiftData
//
//struct BookView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query var books: [Book]
//    @State private var presentCreateFolderSheet: Bool = false
//    @State private var searchText = ""
//
//    var body: some View {
//        NavigationStack {
//            contentView
//                .navigationTitle("Books")
//                .toolbar {
//                    ToolbarItem(placement: .topBarTrailing) {
//                        NavigationLink(destination: AddBookView(), label: { Text("Add Book") })
//                    }
//                }
//        }
//        .searchable(text: $searchText, prompt: "Search for Book")
//    }
//
//    private var contentView: some View {
//        if !filteredBooks.isEmpty {
//            BookListView(books: filteredBooks)
//        } else {
//            EmptyBookView()
//        }
//    }
//
//    var filteredBooks: [Book] {
//        // Implement your filtering logic here (same as before)
//        if searchText.isEmpty {
//                    return books // Show all books if search text is empty
//                } else {
//                    return books.filter { book in
//                        book.title.localizedStandardContains(searchText, options: .caseInsensitive) || // Filter by title (case-insensitive)
//                            book.author?.localizedStandardContains(searchText, options: .caseInsensitive) ?? false  Filter by author (optional chaining for safety)
//                    }
//                }
//    }
//}
//
//struct BookListView: View {
//    let books: [Book]
//
//    var body: some View {
//        List {
//            ForEach(books) { book in
//                BookRowView(book: book) // Replace with your actual book row view
//            }
//        }
//    }
//}
//
//struct EmptyBookView: View {
//    var body: some View {
//        VStack(alignment: .center) {
//            Text("No books found for your search.")
//            Text("You can also add new books.")
//        }
//    }
//}
//
//
//#Preview {
//    BookView()
//}
