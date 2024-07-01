import SwiftUI
import PhotosUI

struct Goal: Hashable {
    let title: String
    let imageName: String
    let imgColor: Color
}

struct AddBookView: View {
    @State private var title = ""
    @State private var author = ""
    @State private var selectedGoals = Set<String>()
    @State private var photoData: Data?
    @State private var showCamera = false
    @State private var inputImage: UIImage?
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // Optional: Add binding for existing book if editing
    var existingBook: Book?
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    // Add additional state variable for editing
    @State private var isEditing = false
    
    // Goals data for demonstration
    let availableGoals: [Goal] = [
        Goal(title: "Deepen your self-understanding", imageName: "deepenYourSelfUnderstanding_Goal", imgColor: Color("color1")),
        Goal(title: "Ignite your motivation", imageName: "igniteYourMotivation_Goal", imgColor: Color("color1")),
        Goal(title: "Expand your skills and knowledge", imageName: "expandYourSkillsAndKnowledge_Goal", imgColor: Color("color1")),
        Goal(title: "Overcome challenges", imageName: "overcomeChallenges_Goal", imgColor: Color("color1")),
        Goal(title: "Enhance relationships and communication", imageName: "enhanceRelationshipAndCommunication_Goal", imgColor: Color("color1")),
        Goal(title: "Discover inner peace and happiness", imageName: "discoverInnerPeaceAndHappiness_Goal", imgColor: Color("color1"))
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    bookCoverSection
                    detailBookSection
                    purposeSection
                }
                .navigationTitle(isEditing ? "Edit Book" : "Add Book")
                .toolbar {
                    ToolbarItem() {
                        Button(isEditing ? "Update" : "Save") {
                            if isEditing {
                                updateBook()
                            } else {
                                saveBook()
                            }
                        }
                    }
                }
                .sheet(isPresented: $showCamera, onDismiss: loadImage) {
                    ImagePicker(image: $inputImage)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Incomplete Information"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .onAppear {
                if let book = existingBook {
                    title = book.title
                    author = book.author
                    selectedGoals = Set(book.goals)
                    photoData = book.bookCover
                    isEditing = true
                }
            } }}

    
    private var bookCoverSection: some View {
        Section(header: Text("Book Cover")) {
            VStack {
                if let photoData = photoData, !photoData.isEmpty, let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                } else {
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.blue) // Change color as needed
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
    
    private var detailBookSection: some View {
        Section(header: Text("Detail Book")) {
            TextField("Enter Title", text: $title)
            TextField("Enter Author", text: $author)
        }
    }
    
    private var purposeSection: some View {
        Section(header: Text("What's your purpose for this book?")) {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.fixed(150), spacing: 16),
                    GridItem(.fixed(150), spacing: 16)
                ], spacing: 16) {
                    ForEach(availableGoals, id: \.self) { goal in
                        GoalItemView(
                            goal: goal,
                            isSelected: selectedGoals.contains(goal.title),
                            toggleAction: {
                                if selectedGoals.contains(goal.title) {
                                    selectedGoals.remove(goal.title)
                                } else {
                                    selectedGoals.insert(goal.title)
                                }
                            }
                        )
                    }
                }
                .padding(.all, 16)
            }
        }
    }
    
    private func saveBook() {
        guard !title.isEmpty else {
            alertMessage = "Please enter the book title."
            showAlert = true
            return
        }
        
        guard !selectedGoals.isEmpty else {
            alertMessage = "Please select at least one goal."
            showAlert = true
            return
        }
        
        let defaultAuthor = "-"
        let defaultPhotoData = UIImage(systemName: "book.fill")?.jpegData(compressionQuality: 0.8)
        
        let book = Book(
            title: title,
            author: author.isEmpty ? defaultAuthor : author,
            bookCover: photoData ?? defaultPhotoData,
            goals: Array(selectedGoals),
            isPinned: false
        )
        
        context.insert(book)
        do {
            try context.save()
            dismiss()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func updateBook() {
        guard let existingBook = existingBook else { return }
        
        existingBook.title = title
        existingBook.author = author
        existingBook.bookCover = photoData
        existingBook.goals = Array(selectedGoals)
        
        do {
            try context.save()
            dismiss()
        } catch {
            print("Failed to update book: \(error.localizedDescription)")
        }
    }
    
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        photoData = inputImage.jpegData(compressionQuality: 0.8)
    }
}

struct GoalItemView: View {
    let goal: Goal
    let isSelected: Bool
    let toggleAction: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: goal.imageName) // Placeholder system image, replace with actual image loading
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(isSelected ? .blue : .gray) // Adjust colors based on selection
            
            Text(goal.title)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .foregroundColor(isSelected ? .blue : .black) // Adjust colors based on selection
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(isSelected ? Color.yellow : Color.clear) // Adjust background color based on selection
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onTapGesture {
            toggleAction()
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
