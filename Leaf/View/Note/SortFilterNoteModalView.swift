import SwiftUI

struct SortFilterNoteModalView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: NoteViewModel
    let allTags: [String]
    
    init(viewModel: NoteViewModel, allTags: [String]) {
        self.viewModel = viewModel
        self.allTags = allTags
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle)
                .withDesign(.serif)!
                .withSymbolicTraits(.traitBold)!,
                size: 28),
            .foregroundColor: UIColor.color1 // Change this to your desired color
        ]
    }
    
    var body: some View {
        NavigationView {
            Form {
                sortOrderSection
                filterByTagSection
            }
            .navigationTitle("Sort and Filter Note")
            .accentColor(.color1)
            .navigationBarItems(trailing: doneButton)
        }
        .onAppear {
                   viewModel.setAllTags(allTags)
               }
    }
    
    private var sortOrderSection: some View {
        Section(header: Text("Sort Order")) {
            Picker("Sort Order", selection: $viewModel.sortOrder) {
                ForEach(NoteViewModel.SortOrder.allCases, id: \.self) { order in
                    Text(order.rawValue.capitalized)
                        .tag(order)
                }
            }
            .pickerStyle(.inline)
            .labelsHidden()
        }

    }
    
    
    private var filterByTagSection: some View {
        Section(header: Text("Filter by Tags")) {
            ForEach(viewModel.allTags, id: \.self) { tag in
                Button(action: {
                    toggleTagSelection(tag)
                }) {
                    HStack {
                        Text(tag)
                        Spacer()
                        if viewModel.selectedTags.contains(tag) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            
            if !viewModel.selectedTags.isEmpty {
                Button("Clear All", action: clearAllTags)
                    .foregroundColor(.red)
            }
        }
    }
    
    private func toggleTagSelection(_ tag: String) {
        if viewModel.selectedTags.contains(tag) {
            viewModel.selectedTags.remove(tag)
        } else {
            viewModel.selectedTags.insert(tag)
        }
    }
    
    private func clearAllTags() {
        viewModel.selectedTags.removeAll()
    }
    
    private var doneButton: some View {
        Button("Done") {
            dismiss()
        }
        .foregroundColor(.color2)
        .bold()
    }
}

// Preview
struct SortFilterNoteModalView_Previews: PreviewProvider {
    static var previews: some View {
        SortFilterNoteModalView(viewModel: NoteViewModel(), allTags: ["Tag 1", "Tag 2", "Tag 3"])
    }
}
