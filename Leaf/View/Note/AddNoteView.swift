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
    @State private var showMarkup = false
    @State private var inputImage: UIImage?
    
    @State private var selectedGoal: String?
    @State private var goalPrompts: [String] = []

    @Environment(\.dismiss) private var dismiss
    
    var book: Book
    var note: Note?
    
    let goalsWithPrompts: [GoalPrompt] = [
        GoalPrompt(goal: "Deepen your self-understanding", prompts: ["What did you learn about yourself?", "How did this change your perspective?"]),
        GoalPrompt(goal: "Ignite your motivation", prompts: ["What inspired you?", "What action will you take?"]),
        GoalPrompt(goal: "Expand your skills and knowledge", prompts: ["What new skill did you learn?", "How will you apply this knowledge?"]),
        GoalPrompt(goal: "Overcome challenges", prompts: ["What challenges did you face?", "How did you overcome them?"]),
        GoalPrompt(goal: "Enhance relationships and communication", prompts: ["How did this improve your relationships?", "What communication skills did you use?"]),
        GoalPrompt(goal: "Discover inner peace and happiness", prompts: ["What brought you peace?", "What made you happy?"])
    ]
    
    init(book: Book, note: Note? = nil) {
        self.book = book
        self.note = note
        _title = State(initialValue: note?.title ?? "")
        _content = State(initialValue: note?.content ?? "")
        _page = State(initialValue: note?.page != nil ? String(note!.page!) : "")
        _prompt = State(initialValue: note?.prompt ?? "")
        _tags = State(initialValue: note?.tag?.compactMap { $0 } ?? [])
        _photoData = State(initialValue: note?.imageNote)
        _selectedGoal = State(initialValue: note?.books?.goals.first(where: { goal in
            goalsWithPrompts.contains { $0.goal == goal }
        }))
        _goalPrompts = State(initialValue: note != nil ? (goalsWithPrompts.first(where: { $0.goal == note!.books?.goals.first(where: { goal in
            goalsWithPrompts.contains { $0.goal == goal }
        }) })?.prompts ?? []) : [])
    }
    
    var body: some View {
        NavigationStack{
            Form {
                photoSection
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                }
                Section(header: Text("Page")) {
                    TextField("Enter page number", text: $page)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("")) {
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
                    
                        TextEditor(text: $content)
                }
               
                Section(header: Text("Tags")) {
                    TagInputView(tags: $tags)
                }
            }
        }
        .navigationTitle(note == nil ? "Add Note" : "Edit Note")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(note == nil ? "Save" : "Update", action: addOrUpdateNote)
                    }
                }
        .fullScreenCover(isPresented: $showCamera, onDismiss: loadImage) {
            ImagePicker(image: $inputImage)
                .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $showMarkup) {
            MarkupView(photoData: $photoData)
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

    private func addOrUpdateNote() {
        if let note = note {
            note.title = title
            note.page = Int(page)
            note.content = content
            note.lastModified = Date()
            note.prompt = prompt
            note.tag = tags
            note.imageNote = photoData
        } else {
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
        showMarkup = true
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
