//
//  AddNoteView.swift
//  Leaf
//
//  Created by Marizka Ms on 27/06/24.
//

import SwiftUI
import SwiftData

struct AddNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var notes: [Note]
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var page: String = ""
    @State private var prompt: String = ""
    @State private var tags: [String] = []
    @State private var photoData: Data?
    @State private var showCamera = false
    @State private var inputImage: UIImage?
    
    @State private var selectedGoal: String?
    @State private var goalPrompts: [String] = []

    @Environment(\.dismiss) private var dismiss
    
    var book: Book
    
    let goalsWithPrompts: [GoalPrompt] = [
        GoalPrompt(goal: "Deepen your self-understanding", prompts: ["What did you learn about yourself?", "How did this change your perspective?"]),
        GoalPrompt(goal: "Ignite your motivation", prompts: ["What inspired you?", "What action will you take?"]),
        GoalPrompt(goal: "Expand your skills and knowledge", prompts: ["What new skill did you learn?", "How will you apply this knowledge?"]),
        GoalPrompt(goal: "Overcome challenges", prompts: ["What challenges did you face?", "How did you overcome them?"]),
        GoalPrompt(goal: "Enhance relationships and communication", prompts: ["How did this improve your relationships?", "What communication skills did you use?"]),
        GoalPrompt(goal: "Discover inner peace and happiness", prompts: ["What brought you peace?", "What made you happy?"])
    ]
    
    var body: some View {
        Form {
            photoSection
            Section(header: Text("Title")) {
                TextField("Enter title", text: $title)
            }
            Section(header: Text("Page")) {
                TextField("Enter page number", text: $page)
                    .keyboardType(.numberPad)
            }
            Section(header: Text("Prompt")) {
                Picker("Select Goal", selection: $selectedGoal) {
                    ForEach(book.goals, id: \.self) { goal in
                        Text(goal).tag(goal as String?)
                    }
                }
                .onChange(of: selectedGoal) { newValue in
                    if let goal = newValue,
                       let prompts = goalsWithPrompts.first(where: { $0.goal == goal })?.prompts {
                        goalPrompts = prompts
                    } else {
                        goalPrompts = []
                    }
                }
                if !goalPrompts.isEmpty {
                    Picker("Select Prompt", selection: $prompt) {
                        ForEach(goalPrompts, id: \.self) { prompt in
                            Text(prompt).tag(prompt)
                        }
                    }
                } else {
                    Text("No prompts available for the selected goal")
                        .foregroundColor(.gray)
                }
            }
            Section(header: Text("Content")) {
                TextEditor(text: $content)
            }
            Section(header: Text("Tags")) {
                TagInputView(tags: $tags)
            }
            Button(action: addNote) {
                Text("Save")
            }
        }
        .navigationTitle("Add Note")
        .fullScreenCover(isPresented: $showCamera, onDismiss: loadImage) {
            ImagePicker(image: $inputImage)
        }
    }
    
    private var photoSection: some View {
        Section(header: Text("Photo")) {
            VStack {
                if let photoData = photoData, let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                } else {
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.gray)
                        .padding(70)
                }
                
                Divider()
                
                Button(action: {
                    showCamera = true
                }) {
                    Text("Take Photo")
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }

    private func addNote() {
        let newNote = Note(
            title: title,
            imageNote: photoData,
            page: Int(page),
            content: content,
            lastModified: Date(),
            prompt: prompt,
            tag: tags,
            books: book
           
        )
        modelContext.insert(newNote)
        
        if book.notes == nil {
            book.notes = [newNote]
        } else {
            book.notes?.append(newNote)
        }
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error saving note: \(error.localizedDescription)")
        }
    }
    
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        photoData = inputImage.jpegData(compressionQuality: 0.8)
    }
}

struct GoalPrompt {
    let goal: String
    let prompts: [String]
}


//struct AddNoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddNoteView(book: Book(backingData: <#any BackingData<Book>#>), goalsWithPrompts: [
//            GoalPrompt(goal: "Sample Goal 1", prompts: ["Prompt 1", "Prompt 2"]),
//            GoalPrompt(goal: "Sample Goal 2", prompts: ["Prompt A", "Prompt B"])
//        ])
//    }
//}
