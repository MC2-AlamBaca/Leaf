//
//  NoteListView.swift
//  Leaf
//
//  Created by Marizka Ms on 27/06/24.
//

import SwiftUI
import SwiftData

struct NoteListView: View {
    @Environment(\.modelContext) private var modelContext
    var book: Book
    @StateObject var viewModel : NoteViewModel
    @State private var noteToDelete: Note? //Track book yang akan di delete
    @State private var showDeleteConfirmation: Bool = false //confimasi untuk delete
    
    let availableGoals: [Goal] = [
        Goal(title: "Deepen your self-understanding", imageName: "deepenYourSelfUnderstanding_Goal", imgColor: Color("Color 1")),
        Goal(title: "Ignite your motivation", imageName: "igniteYourMotivation_Goal", imgColor: Color("color1")),
        Goal(title: "Expand your skills and knowledge", imageName: "expandYourSkillsAndKnowledge_Goal", imgColor: Color("color1")),
        Goal(title: "Overcome challenges", imageName: "overcomeChallenges_Goal", imgColor: Color("color1")),
        Goal(title: "Enhance relationships and communication", imageName: "enhanceRelationshipAndCommunication_Goal", imgColor: Color("color1")),
        Goal(title: "Discover inner peace and happiness", imageName: "discoverInnerPeaceAndHappiness_Goal", imgColor: Color("color1"))
    ]

    
    
    var body: some View {
        List {
            Section("Your Goal"){
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(book.goals, id: \.self) { goal in
                            if let imageName = getGoalImageName(for: goal) {
                                Image(imageName)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.color1)
                            }
                            Text(goal)
                                .font(.callout)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 3)
                                .italic()
                                .fontWeight(.semibold)
                                .fontDesign(.serif)
                        
                        }

                    }
                    .padding(.horizontal)
                }
            }
            
            
            ForEach(viewModel.filteredAndSortedNotes(book.notes ?? [])) { note in
                NavigationLink(destination: NoteDetailView(note: note)) {
                    NoteRowView(note: note)
                }
                .swipeActions(edge: .leading) {
                    Button {
                        togglePinNote(note)
                    } label: {
                        Label(note.isPinned ? "Unpin" : "Pin", systemImage: note.isPinned ? "pin.slash" : "pin")
                    }
                    .tint(.yellow)
                }
                .swipeActions(edge: .trailing) {
                    Button() {
                        noteToDelete = note
                        showDeleteConfirmation = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                }
            }
        }
        .alert (isPresented: $showDeleteConfirmation){
            Alert(
                title: Text("Delete Note"),
                message: Text("Are you sure you want to delete this note? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")){
                    if let noteToDelete = noteToDelete {
                        deleteNote(noteToDelete)
                    }
                },
                secondaryButton: .cancel())
        }
        .listRowSpacing(10)
    }
    
    private func togglePinNote(_ note: Note) {
        note.isPinned.toggle()
        note.lastModified = Date()
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context after pinning note: \(error.localizedDescription)")
        }
    }
    
    private func deleteNote(_ note: Note) {
        modelContext.delete(note)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context after deleting note: \(error.localizedDescription)")
        }
    }
    
    func getGoalImageName(for title: String) -> String? {
        return availableGoals.first { $0.title == title }?.imageName
    }
    
}
//#Preview {
//    // Create a mock ModelContainer
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: Book.self, Note.self, configurations: config)
//
//    // Create a sample book
//    let book = Book(title: "Sample Book", author: "John Doe", goals: ["Goal1"], isPinned: true)
//    
//    // Save the book first
//    let context = container.mainContext
//    context.insert(book)
//    
//    // Create a sample image (optional)
//    let sampleImage = UIImage(systemName: "book.fill")
//    let imageData = sampleImage?.pngData()
//    
//    // Create a sample note
//    let note = Note(
//        title: "Chapter 1 Summary",
//        imageNote: imageData,
//        page: 20,
//        content: "This is a summary of chapter 1. It contains important points about the introduction of the main character. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
//        lastModified: Date(),
//        prompt: "Summarize the key points of Chapter 1",
//        tag: ["Chapter1", "Summary", "Introduction"],
//        books: book
//    )
//    
//    context.insert(note)
//    
//    // Save the context to ensure all data is committed
//    try! context.save()
//
//    // Return the preview
//    return NoteDetailView(note: note)
//        .modelContainer(container)
//}
