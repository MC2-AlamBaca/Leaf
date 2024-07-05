//
//  NoteDetailView.swift
//  Leaf
//
//  Created by Marizka Ms on 01/07/24.
//

import SwiftUI
import SwiftData

struct NoteDetailView: View {
    var note: Note
    //    @State private var isEditing = false
    //    @State private var editedNote: Note?
    
    
    var body: some View {
        ScrollView() {
            VStack(alignment: .leading) {
                
                Text(note.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)
                    .fontDesign(.serif)
                    .bold()
                    .padding(.bottom, 4)
                
                Text("Last Modified: \(note.lastModified, formatter: dateFormatter)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.footnote)
                    .padding(.horizontal, 4)
                    .padding(.bottom, 12)
                
                Divider()
                
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
                        Spacer()
                        HStack {
                            Spacer()
                            Text("Page \(note.page ?? 0)")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .foregroundColor(note.imageNote == nil ? Color("Color 2") : .white)
                                .padding(.horizontal, 8)
                                .padding(.top, 2)
                                .padding(.bottom, 20)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .italic()
                                .fontDesign(.serif)
                        }
                    }
                    
                    
                }
                .padding(.top, 12)
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
            //            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)// tipe navbartype
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddNoteView(book: note.books!, note: note)) {
                    Text("Edit")
                }
            }
        }
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
        books: book
    )
    
    context.insert(note)
    
    // Save the context to ensure all data is committed
    try! context.save()
    
    // Return the preview
    return NoteDetailView(note: note)
        .modelContainer(container)
}
