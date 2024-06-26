//
//  AddBookView.swift
//  Leaf
//
//  Created by Diky Nawa Dwi Putra on 26/06/24.
//

import SwiftUI
import PhotosUI

struct AddBookView: View {
    
    @State private var title = ""
    @State private var author = ""
    @State private var imageBook = ""
    @State private var selectedGoals = Set<String>()
    @State var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    let availableGoals = [
        "Deepen your self-understanding",
        "Ignite your motivation",
        "Expand your skills and knowledge",
        "Overcome challenges",
        "Enhance relationships and communication",
        "Discover inner peace and happiness"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Book Cover")) {
                    VStack {
                        if let photoData, let uiImage = UIImage(data: photoData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 300)
                        }
                        Divider()
                        PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                            Label("Select image...", systemImage: "photo.on.rectangle")
                        }
                        .onChange(of: selectedPhoto) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    photoData = data
                                }
                            }
                        }
                        Spacer()
                    }
                }
                
                Section(header: Text("Detail Book")) {
                    TextField("Enter Title", text: $title)
                    TextField("Enter Author", text: $author)
                }
                
                Section(header: Text("What's your purpose for this book?")) {
                    LazyVGrid(columns: [
                        GridItem(.fixed(150)),
                        GridItem(.fixed(150))
                    ], spacing: 16) {
                        ForEach(availableGoals, id: \.self) { goal in
                            GoalItemView(
                                goal: goal,
                                isSelected: selectedGoals.contains(goal),
                                toggleAction: {
                                    if selectedGoals.contains(goal) {
                                        selectedGoals.remove(goal)
                                    } else {
                                        selectedGoals.insert(goal)
                                    }
                                }
                            )
                        }
                    }
                }
            }
            .navigationTitle("Add Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: saveBook, label: {
                        Text("Save")
                    })
                }
            }
        }
    }
    
    private func saveBook() {
        guard !title.isEmpty, !author.isEmpty, let photoData = photoData else {
            // Show an alert or some feedback to the user
            return
        }
        
        let book = Book(title: title, author: author, bookCover: photoData, goals: Array(selectedGoals))
        context.insert(book)
        do {
            try context.save()
            dismiss()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Function to get the path to the documents directory
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

struct GoalItemView: View {
    let goal: String
    let isSelected: Bool
    let toggleAction: () -> Void
    
    var body: some View {
        Text(goal)
            .font(.body)
            .multilineTextAlignment(.center)
            .padding()
            .background(isSelected ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onTapGesture {
                toggleAction()
            }
            .frame(width: 150, height: 100)
    }
}

#Preview {
    AddBookView()
}
