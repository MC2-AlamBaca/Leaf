import SwiftUI
import PhotosUI

struct AddBookView: View {
    @State private var title = ""
    @State private var author = ""
    @State private var selectedGoals = Set<String>()
    @State private var photoData: Data?
    @State private var showCamera = false
    @State private var showMarkup = false
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
        Goal(title: "Deepen your self-understanding", imageName: "deepenYourSelfUnderstanding_Goal", imgColor: Color("Color 1")),
        Goal(title: "Ignite your motivation", imageName: "igniteYourMotivation_Goal", imgColor: Color("color1")),
        Goal(title: "Expand your skills and knowledge", imageName: "expandYourSkillsAndKnowledge_Goal", imgColor: Color("color1")),
        Goal(title: "Overcome challenges", imageName: "overcomeChallenges_Goal", imgColor: Color("color1")),
        Goal(title: "Enhance relationships and communication", imageName: "enhanceRelationshipAndCommunication_Goal", imgColor: Color("color1")),
        Goal(title: "Discover inner peace and happiness", imageName: "discoverInnerPeaceAndHappiness_Goal", imgColor: Color("color1"))
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    bookCoverSection
                    detailBookSection
                    purposeSection
                }
                .navigationTitle(isEditing ? "Edit Book" : "Add Book")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(isEditing ? "Update" : "Save") {
                            if isEditing {
                                updateBook()
                            } else {
                                saveBook()
                            }
                        }
                    }
                }
                .foregroundColor(.color2)
                
                .navigationBarItems(leading:
                                    Button(action: {
                                        dismiss() // Dismiss action for custom "Back" button
                                    }) {
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(.color2) // Customize back button color
                                            .imageScale(.large)
                                        Text("Books")
                                            .foregroundColor(.color2)
                                    }
                                )
                
                .fullScreenCover(isPresented: $showCamera, onDismiss: loadImage) {
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
            }
        }
        .fontDesign(.serif)
    }
    
    private var bookCoverSection: some View {
        Section(header: Text("Book Cover").foregroundColor(.color2)) {
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
                        .foregroundColor(.color1) // Change color as needed
                        .padding(70)
                }
                
                Divider()
                
                Button(action: {
                    showCamera = true
                }) {
                    Text("Take Photo")
                        .foregroundColor(.color2)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.color1)
                }
            }
        }
    }
    
    private var detailBookSection: some View {
        Section(header: Text("Detail Book").foregroundColor(.color2)) {
            TextField("Enter Title", text: $title).foregroundColor(.color1)
            TextField("Enter Author", text: $author).foregroundColor(.color1)
        }
        
    }
        
    
    private var purposeSection: some View {
        Section(header: Text("What's your purpose for this book?").foregroundColor(.color2)) {
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
            // Load the image using the asset name
            Image(goal.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(isSelected ? .white : .black) // Adjust colors based on selection
            
            Text(goal.title)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .foregroundColor(isSelected ? .white : .black) // Adjust colors based on selection
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(isSelected ? Color.color1 : Color.color3) // Adjust background color based on selection
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
