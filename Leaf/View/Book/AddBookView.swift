import SwiftUI
import PhotosUI

struct AddBookView: View {
    @State private var title = ""
    @State private var author = ""
    @State private var selectedGoals = Set<String>()
    @State private var photoData: Data?
    @State private var showCamera = false
    @State private var inputImage: UIImage?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @StateObject private var viewModel = PhotoViewModel()
    
    // Add additional state variable for editing
    @State private var isEditing = false
    
    // Optional: Add binding for existing book if editing
    var existingBook: Book?
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    let availableGoals = [
        "Deepen your self-understanding",
        "Ignite your motivation",
        "Expand your skills and knowledge",
        "Overcome challenges",
        "Boost discussion and relationships",
        "Discover inner peace and happiness"
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
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(isEditing ? "Update" : "Save", action: isEditing ? updateBook : saveBook)
                    }
                }
                .fullScreenCover(isPresented: $showCamera, onDismiss: loadImage) {
                    ImagePicker(image: $inputImage)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Incomplete Information"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
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
                        .foregroundColor(.gray)
                        .padding(70)
                }
                
                Divider()
                
                Button(action: {
                    showCamera = true
                }) {
                    Text("Take Photo")
                        .frame(maxWidth: .infinity) // This will make the text centered within the button
                }
            }
        }
    }
    
    private var detailBookSection: some View {
        Section(header: Text("Detail Book")) {
            HStack {
                Text("Title")
                  .font(Font.custom("SF Pro", size: 17))
                  .frame(width: 60, height: 22, alignment: .leading)
                TextField("Enter Title", text: $title)
            }
            
            HStack {
                Text("Author")
                  .font(Font.custom("SF Pro", size: 17))
                  .frame(width: 60, height: 22, alignment: .leading)
                TextField("Enter Author", text: $author)
            }
        }
    }
    
    private var purposeSection: some View {
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
            isPinned: false)
        
        context.insert(book)
        do {
            try context.save()
            viewModel.saveDataToPhoto()
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
    let goal: String
    let isSelected: Bool
    let toggleAction: () -> Void
    
    var body: some View {
        VStack {
            Text(goal)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(isSelected ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .onTapGesture {
                    toggleAction()
                }
                .frame(width: 150, height: 100)
                .shadow(radius: isSelected ? 10 : 5)  // Adding a shadow for better UI feedback
                .animation(.easeInOut, value: isSelected) // Smooth transition for selection state
        }
        .frame(width: 150, height: 100)  // Ensure the card size is fixed
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
