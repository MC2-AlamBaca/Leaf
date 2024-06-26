import SwiftUI
import PhotosUI

struct AddBookView: View {
    @State private var title = ""
    @State private var author = ""
    @State private var selectedGoals = Set<String>()
    @State private var photoData: Data?
    @State private var showCamera = false
    @State private var inputImage: UIImage?
    
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
                bookCoverSection
                detailBookSection
                purposeSection
            }
            .navigationTitle("Add Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save", action: saveBook)
                }
            }
            .sheet(isPresented: $showCamera, onDismiss: loadImage) {
                ImagePicker(image: $inputImage)
            }
        }
    }
    
    private var bookCoverSection: some View {
        Section(header: Text("Book Cover")) {
            VStack {
                if let photoData = photoData, let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                }
                Divider()
                Button(action: {
                    showCamera = true
                }) {
                    Label("Take Photo", systemImage: "camera")
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

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
