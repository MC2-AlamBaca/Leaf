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
    @State private var isFullScreenImagePresented = false
    
    
    var body: some View {
        
        ScrollView() {
            VStack(alignment: .leading) {
                
                Text(note.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title2)
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
                        Color.clear
                            .frame(width: 330, height: 440)
                            .overlay(
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay {
                                Rectangle()
                                    .foregroundStyle(LinearGradient(colors: [
                                        Color("Color 1").opacity(1), Color.black.opacity(0)
                                    ], startPoint: .bottom, endPoint: UnitPoint(x: 0.5, y: 0.8)))
                            }
                        
                            .mask {
                                RoundedRectangle(cornerRadius: 20)
                            }
                        
                            .onTapGesture {
                                print("Image tapped, presenting full screen")
                                isFullScreenImagePresented = true
                            }
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("Page \(note.page ?? 0)")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .foregroundColor(note.imageNote == nil ? Color("Color 2") : .white)
                                .padding(.horizontal, 32)
                                .padding(.top, 8)
                                .padding(.bottom, 12)
                                .font(.footnote)
                                .fontWeight(.medium)
                                .italic()
                                .fontDesign(.serif)
                        }
                    }
                    
                    
                }
                .padding(.top, 12)
                
                VStack {
                    Text(note.prompt)
                        .fontDesign(.serif)
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color("Color 1"))
                        .padding(.bottom, 8)
                    
                    Text(note.content)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color("Color 2"))
                        .padding(.bottom, 8)
                    
                    if let tags = note.tag, !tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: true){
                            HStack {
                                ForEach(tags, id: \.self) { tag in
                                    Text(tag ?? "")
                                        .font(.footnote)
                                        .fontDesign(.serif)
                                        .foregroundColor(Color("Color 2"))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(Color.secondary.opacity(0.1))
                                        .cornerRadius(20)
                                        .padding(.top, 8)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding()
            }
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
        .fullScreenCover(isPresented: $isFullScreenImagePresented) {
            FullScreenImageView(imageData: note.imageNote!)
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct FullScreenImageView: View {
    var imageData: Data
    @Environment(\.presentationMode) var presentationMode
    @State private var zoomScale: CGFloat = 1.0
    
    var body: some View {
        NavigationStack {
            if let image = UIImage(data: imageData) {
                VStack {
                    Spacer()
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .edgesIgnoringSafeArea(.all)
                        .scaleEffect(zoomScale)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { gestureScale in
                                    zoomScale = gestureScale.magnitude
                                }
                        )
                    Spacer()
                }
                .background(Color.black)
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button("Back") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .tint(.color2)
                        .bold()
                    }
                }
            } else {
                Text("Image not available")
            }
        }//navstack
        
    }
}


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
    return NoteDetailView(note: note)
        .modelContainer(container)
}
