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
    
    @State private var selectedGoal: String? = nil
    @State private var goalPrompts: [String] = []
    
    @State private var isTitleFocused: Bool = true
   
    @State private var selectedPrompt: String = ""

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
                Section(header: Text("title").foregroundColor(.color2)) {
                    FocusableTextField(text: $title, placeholder: "Enter title")
                        .focused(isTitleFocused)
                }
                
                photoSection
                
                Section(header: Text("page").foregroundColor(.color2)) {
                    TextField("Enter page number", text: $page)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("goal & prompt")) {
                    Picker("Goal", selection: $selectedGoal) {
                        Text ("Select Goal")
                        ForEach(book.goals, id: \.self) { goal in
                            Text(goal).tag(goal as String?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
//                    .labelsHidden()
                    // ZAHRA, INI YA DI LINE 77 DITAMBAH TINT COLORNYA SUPAYA BISA SELECTED PICKERNYA PAKAI WARNA YG DIINGINKAN
                    .tint(.color2)
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    
                    
                    //Picker Prompt
                    if !goalPrompts.isEmpty {
                        Picker(selection: $prompt, label: Text("Select Prompt").foregroundColor(.color2)) {
                            Text ("Select Prompt")
                            ForEach(goalPrompts, id: \.self) { prompt in
                                Text(prompt).tag(prompt)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
//                        .labelsHidden()
                        // ZAHRA, INI YA DI LINE 77 DITAMBAH TINT COLORNYA SUPAYA BISA SELECTED PICKERNYA PAKAI WARNA YG DIINGINKAN
                        .tint(.color2)
                        
                        .onChange(of: prompt) { newPrompt in
                            if !newPrompt.isEmpty {
                                selectedPrompt = newPrompt
                            }
                        }
                    } else {
                        Text("No prompts being selected")
                            .foregroundColor(.color4)
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
                Section(header: Text("reflection").foregroundColor(.color2)) {
                    Text(selectedPrompt).font(.caption)
                    TextEditor(text: $content)
                        .frame(minHeight: 150)
                }
                
                Section(header: Text("tags").foregroundColor(.color2)) {
                    TagInputView(tags: $tags)
                }
            }
            .fontDesign(.serif)
            .foregroundColor(.color2)
        }
//        .tint(.red) Bingung caranya mengganti color dari navigation bar nya yang berasal dari yang lain. 
        .navigationTitle(note == nil ? "Add Note" : "Edit Note")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(note == nil ? "Save" : "Update", action: addOrUpdateNote)
                    .foregroundColor(.color2)
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
        Section(header: Text("Sentence Photo").foregroundColor(.color2) ) {
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
                        .foregroundColor(.color4)
                        .padding(70)
                }
                
                Divider()
                
                Button(action: {
                    showCamera = true
                }) {
                    Text("Take Photo")
                        .foregroundColor(.color2)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    private func addOrUpdateNote() {
        if let note = note {
            let originalCreationDate = note.creationDate
            
            note.title = title
            note.page = Int(page)
            note.content = content
            note.lastModified = Date()
            note.prompt = prompt
            note.tag = tags
            note.imageNote = photoData
            note.creationDate = originalCreationDate
        } else {
            let newNote = Note(
                title: title,
                imageNote: photoData,
                page: Int(page),
                content: content,
                lastModified: Date(),
                prompt: prompt,
                tag: tags,
                books: book,
                creationDate: Date()
            )
            modelContext.insert(newNote)
            
            if book.notes == nil {
                book.notes = [newNote]
            } else {
                book.notes?.append(newNote)
            }
            // Schedule notifications for the new note
            NotificationScheduler.scheduleNotifications(for: newNote)
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
