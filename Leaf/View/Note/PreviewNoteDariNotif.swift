//
//  PreviewNoteDariNotif.swift
//  Leaf
//
//  Created by Zahratul Wardah on 05/07/24.
//

import SwiftUI
import SwiftData

struct PreviewNoteDariNotif: View {
    var note: Note
    
    var body: some View {
        
        ScrollView() {
            ZStack{
                VStack(alignment:.trailing) {
                    HStack {
                        VStack(alignment:.trailing){
                            Text(note.books?.title ?? "No Book Title")
                                .font(.caption)
                                .bold()
                                
                            Text(note.books?.author ?? "No Book Author")
                                .font(.caption)
                            
                            Text("Pg \(note.page ?? 0)")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .foregroundColor(note.imageNote == nil ? Color("Color 2") : .white)
                                .padding(.bottom, 1)
                                .font(.caption)
                                .italic()
                        }
                        .padding ()
                        }
                    HStack {
                        
                    }
                    
                    ZStack {
                        if let imageData = note.imageNote, let image = UIImage(data: imageData) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 200)
                                .cornerRadius(20)
                                .overlay {
                                    Rectangle()
                                        .foregroundStyle(LinearGradient(colors: [
                                            Color.gray.opacity(1), Color.black.opacity(0)
                                        ], startPoint: .bottom, endPoint: UnitPoint(x: 0.5, y: 0.8)))
                                }
                                .mask {
                                    RoundedRectangle(cornerRadius: 12)
                                }
                        }
                        VStack {
                            HStack {
                            }
                        }
                        
                        
                    }
                    .padding(.horizontal)
                    VStack {
                        Text(note.prompt)
                            .fontDesign(.serif)
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color("Color 1"))
                            .padding(.bottom, 12)
                        
                        Text(note.content)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color("Color 2"))
                            .padding(.bottom, 16)
                        
                        if let tags = note.tag, !tags.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    Image(systemName: "tag.fill")
                                        .foregroundColor(Color("Color 2"))
                                        .padding(.trailing, 4)
                                    
                                    HStack {
                                        ForEach(tags.compactMap { $0 }, id: \.self) { tag in
                                            Text(tag)
                                                .cornerRadius(15)
                                                .foregroundColor(Color("Color 2"))
                                                .bold()
                                                .fontDesign(.serif)
                                                .font(.subheadline)
                                                .padding(.leading, -4)
                                            Text(",")
                                                .padding(.leading, -8)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)// tipe navbartype
            .padding()
            .background(.gray)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            
        }
        .padding()
        .foregroundColor(.color1)
        .padding()
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()


#Preview {
    // Create a mock ModelContainer
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Book.self, Note.self, configurations: config)
    
    // Create a sample book
    let book = Book(title: "Sample Book", author: "John Doe", goals: ["Goal1"], isPinned: true)
    
    // Save the book first
    let context = container.mainContext
    context.insert(book)
    
    // Create a sample image (optional)
    let sampleImage = UIImage(systemName: "")
    let imageData = sampleImage?.pngData()
    
    // Create a sample note
    let note = Note(
        title: "Chapter 1 Summary",
        imageNote: imageData,
        page: 20,
        content: "This is a summary of chapter 1. It contains important points about the introduction of the main character. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        lastModified: Date(),
        prompt: "Summarize the key points of Chapter 1",
        tag: ["Chapter1", "Summary", "Introduction"],
        books: book, creationDate: Date()
    )
    
    context.insert(note)
    
    // Save the context to ensure all data is committed
    try! context.save()
    
    // Return the preview
    return PreviewNoteDariNotif(note: note)
        .modelContainer(container)
}
