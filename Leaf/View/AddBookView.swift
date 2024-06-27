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
            VStack {
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
            HStack{
                Text("Title")
                  .font(Font.custom("SF Pro", size: 17))
                  .foregroundColor(.black)
                  .frame(width: 60, height: 22, alignment: .leading)
                TextField("Enter Title", text: $title)
            }
            
            HStack {
                Text("Author")
                  .font(Font.custom("SF Pro", size: 17))
                  .foregroundColor(.black)
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
