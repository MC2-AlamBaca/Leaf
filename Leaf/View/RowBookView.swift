import SwiftUI
import SwiftData

struct RowBookView: View {
    @Environment(\.modelContext) var modelContext
    @Query var books: [Book]
    @State private var image = UIImage(named: "book-logo")!
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    NavigationLink(destination: AllNoteView(book: book)) {
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
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            deleteBook(book: book)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            pinBook(book: book)
                        } label: {
                            Label("Pin", systemImage: "pin")
                        }
                        .tint(.yellow)
                    }
                }
            }
//            .navigationTitle("Books")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//            }
        }
    }
    
    func deleteBook(book: Book) {
        modelContext.delete(book)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context after deleting book: \(error.localizedDescription)")
        }
    }
    
    func pinBook(book: Book) {
        // Implement your pinning logic here
        // For example, you might set a `isPinned` property on the book
        print("Pinning book: \(book.title)")
    }
}


#Preview {
    RowBookView()
}
