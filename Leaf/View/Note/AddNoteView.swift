import SwiftUI
import SwiftData

struct AddNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var notes: [Note]
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var page: String = ""
    @State private var prompt: String = "Select Prompt"
    @State private var tags: [String] = []
    @State private var photoData: Data?
    @State private var showCamera = false
    @State private var showMarkup = false
    @State private var inputImage: UIImage?
    @State private var placeholderText: Bool = false
    
    @State private var selectedGoal: String? = nil
    @State private var goalPrompts: [String] = []
    
    @State private var isTitleFocused: Bool = true
    
    @State private var selectedPrompt: String = ""
    @State private var selectedGoals: Set<String> = []
    @State private var availablePrompts: [String] = []

    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var detectedText: String = ""

    @Environment(\.dismiss) private var dismiss
    
    var book: Book
    var note: Note?
    
    let goalsWithPrompts: [GoalPrompt] = [
        GoalPrompt(goal: "Deepen your self-understanding", prompts: ["I found an 'aha!' moment about myself when I realized...", "This reading really clicked about myself because..."]),
        GoalPrompt(goal: "Ignite your motivation", prompts: ["A goal that really fuels my passion is...", "I've been fired up by stories or ideas like..."]),
        GoalPrompt(goal: "Expand your skills and knowledge", prompts: ["Excited about new skills or knowledge I've gained, such as...", "I'm reflecting on a skill I'm eager to master, which is..."]),
        GoalPrompt(goal: "Overcome challenges", prompts: ["I've picked up tips from my reading on handling tough spots, like...", "Reflecting on a lesson learned from overcoming adversity..."]),
        GoalPrompt(goal: "Enhance relationships and communication", prompts: ["I've gained insights to strengthen my connections, such as...", "Applying insights from this books enhances my connections by..."]),
        GoalPrompt(goal: "Discover inner peace and happiness", prompts: ["I find resonance with my quest for peace and joy when...", "Applying wisdom from self-improvement books helps me deepen my connection with myself by..."])
    ]
    
    init(book: Book, note: Note? = nil) {
        self.book = book
        self.note = note
        _title = State(initialValue: note?.title ?? "")
        _content = State(initialValue: note?.content ?? "")
        _page = State(initialValue: note?.page != nil ? String(note!.page!) : "")
        _prompt = State(initialValue: note?.prompt ?? "Select Prompt")
        _tags = State(initialValue: note?.tag?.compactMap { $0 } ?? [])
        _photoData = State(initialValue: note?.imageNote)
        
        // Initialize selectedGoals
        if let noteGoals = note?.books?.goals {
            _selectedGoals = State(initialValue: Set(noteGoals.filter { goal in
                goalsWithPrompts.contains { $0.goal == goal }
            }))
        } else {
            _selectedGoals = State(initialValue: Set(book.goals))
        }
        
        // Initialize prompt based on selected goals
        if let notePrompt = note?.prompt, !notePrompt.isEmpty {
            _prompt = State(initialValue: notePrompt)
        } else if let firstSelectedGoal = _selectedGoals.wrappedValue.first,
                  let firstPrompt = goalsWithPrompts.first(where: { $0.goal == firstSelectedGoal })?.prompts.first {
            _prompt = State(initialValue: firstPrompt)
        }
    }
    
    var body: some View {
        NavigationStack{
            Form {
                Section(header: Text("Note Title").foregroundColor(.color1)) {
                    TextField("Enter Note Title", text: $title)
                }
                
                photoSection
                
                Section(header: Text("Page Number").foregroundColor(.color2)) {
                    TextField("Enter Book page number", text: $page)
                        .keyboardType(.numberPad)
                }
                
                Section() {
                    let availablePrompts = getAvailablePrompts()
                    if !availablePrompts.isEmpty {
                        Picker(selection: $prompt, label: Text("Prompt")) {
                            ForEach(availablePrompts, id: \.self) { prompt in
                                Text(prompt)
                                    .tag(prompt)
                                    .font(.system(size: 16, weight:.semibold, design: .serif))
                            }
                        }
                        .multilineTextAlignment(.leading)
                        .frame(height:50)
                        .pickerStyle(NavigationLinkPickerStyle())
                        .labelsHidden()
                        .tint(.color2)
                        .onChange(of: prompt) { newPrompt in
                            if !newPrompt.isEmpty {
                                selectedPrompt = newPrompt
                            }
                        }
                        .fontDesign(.rounded)
                        .italic()
                    } else {
                        Text("No prompts available")
                            .foregroundColor(.color4)
                    }
                    TextEditor(text: $content)
                        .frame(minHeight: 150)
                        .onTapGesture {
                            placeholderText = false
                        }
                        .overlay(
                            VStack {
                                HStack {
                                    if content.isEmpty {
                                        Text("Write your reflection here...")
                                            .foregroundColor(.gray.opacity(0.5))
                                            .font(.body)
                                    }
                                    Spacer()
                                }//HStack
                                Spacer()
                            }//VStack
                            
                        )
                    
                } header: {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Reflection")
                            .font(.system(size: 17, weight: .bold, design: .serif))
                            .foregroundColor(.color1)
                        
                        Text("Prompts can help you reflect on your reading and stay aligned with your goals")
                            .font(.footnote)
                            .foregroundColor(.color2)
                            .textCase(.lowercase)
                    }
                }
                .onAppear {
                    updateAvailablePrompts()
                }
                
                Section(header: VStack(alignment: .leading, spacing: 3) {
                    Text("Tags")
                        .font(.system(size: 17, weight: .bold, design: .serif))
                        .foregroundColor(.color2)
                    
                    Text("Tags can help you filter and find your note quickly")
                        .font(.footnote)
                        .foregroundColor(.color2)
                        .textCase(.lowercase)
                    
                }) {
                    TagInputView(tags: $tags)
                }
                .foregroundColor(.color2)
            }
        }
        .navigationTitle(note == nil ? "Add Note" : "Edit Note")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(note == nil ? "Save" : "Update", action: addOrUpdateNote)
                    .bold()
                    .foregroundColor(.color2)
            }
        }
        .fullScreenCover(isPresented: $showCamera, onDismiss: loadImage) {
            ImagePicker(image: $inputImage)
                .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $showMarkup) {
            MarkupView(photoData: $photoData, detectedText: $detectedText)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Incomplete Information"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        
        
    }
    
    
    private var photoSection: some View {
        Section() {
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
        } header: {
            VStack(alignment: .leading, spacing: 3) {
                Text("Sentence Photo")
                    .font(.system(size: 17, weight: .bold, design: .serif))
                    .foregroundColor(.color1)
                
                Text("Snap a photo of what grabs your attention in the books!")
                    .font(.footnote)
                    .foregroundColor(.color2)
                    .textCase(.lowercase)
            }
        }
    }
    
    func getAvailablePrompts() -> [String] {
        return goalsWithPrompts
            .filter { book.goals.contains($0.goal) }
            .flatMap { $0.prompts }
    }
    
    func updateAvailablePrompts() {
        availablePrompts = getAvailablePrompts()
        if !availablePrompts.contains(prompt) {
            prompt = availablePrompts.first ?? ""
        }
    }
    
    private func addOrUpdateNote() {
        
        guard !content.isEmpty else {
            alertMessage = "Please write your reflection."
            showAlert = true
            return
        }
        
        do {
            if let existingNote = note {
                // Update existing note
                existingNote.title = title
                existingNote.page = Int(page)
                existingNote.content = content
                existingNote.lastModified = Date()
                existingNote.prompt = prompt
                existingNote.tag = tags
                existingNote.imageNote = photoData
            } else {
                // Create new note
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
            
            try modelContext.save()
            dismiss()
        } catch {
            print("Error saving note: \(error.localizedDescription)")
            // Handle error as needed, e.g., show alert
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
