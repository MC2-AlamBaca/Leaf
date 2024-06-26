//
//  RowBookView.swift
//  Leaf
//
//  Created by Marizka Ms on 26/06/24.
//

import SwiftUI
import SwiftData

struct RowBookView: View {
    @Environment(\.modelContext) var modelContext
    @Query var books: [Book]
    @State private var image = UIImage(named: "book-logo")!
    
    
    
    var body: some View {
        List {
            ForEach(books) { book in
                NavigationLink(value: book) {
                    if let photoData = book.bookCover, let uiImage = UIImage(data: photoData) {
                        HStack {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)
                                Text(book.author)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("\(book.notes?.count ?? 0)")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .onDelete(perform: deleteBook)
        }
    }
    
//    init(searchString: String = "", sortOrder: [SortDescriptor<Book>] = []) {
//        _books = Query(filter: #Predicate { book in
//            if searchString.isEmpty {
//                return true
//            } else {
//                return book.title.localizedStandardContains(searchString) ||
//                       book.author.localizedStandardContains(searchString) ||
//                       book.goals.contains { $0.localizedStandardContains(searchString) }
//            }
//        }, sort: sortOrder)
//    }
    
    func deleteBook(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            modelContext.delete(book)
        }
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context after deleting book: \(error.localizedDescription)")
        }
    }
}

#Preview {
    RowBookView()
}
