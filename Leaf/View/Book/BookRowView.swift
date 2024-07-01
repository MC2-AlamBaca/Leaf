import SwiftUI

struct BookRowView: View {
    let book: Book
    
    var body: some View {
        HStack {
            if let photoData = book.bookCover, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(book.title)
                        .font(.headline)
                        .fontDesign(.serif)
                    
                    if book.isPinned {
                        Image(systemName: "pin.fill")
                    }
                }
                Text(book.author)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fontDesign(.serif)
            }
            Spacer()
            Text("\(book.notes?.count ?? 0)")
                .foregroundColor(.secondary)
        }
    }
}

//#Preview {
//    BookRowView(book: <#T##Book#>)
//}
