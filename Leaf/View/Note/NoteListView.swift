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
        VStack {
                
            
            List {
                Section("Your Goal"){
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(book.goals, id: \.self) { goal in
                                if let imageName = getGoalImageName(for: goal) {
                                    Image(imageName)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                                Text(goal)
                                    .font(.callout)
                                //                                .padding(.horizontal, 5)
                                    .padding(.vertical, 3)
                                    .italic()
                                    .fontWeight(.semibold)
                                    .fontDesign(.serif)
                            }
                        }
//                        .background(.red)
                        .cornerRadius(20)
                        .padding(.horizontal)
                    }
                    
                }.listRowBackground(EmptyView())
                
            
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
                        .tint(note.isPinned ? .red : .yellow)
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


