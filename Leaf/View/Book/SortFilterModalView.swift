import SwiftUI

struct SortFilterModalView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: BookViewModel
    let allGoals: [String]
    
    init(viewModel: BookViewModel, allGoals: [String]) {
        self.viewModel = viewModel
        self.allGoals = allGoals
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle)
                .withDesign(.serif)!
                .withSymbolicTraits(.traitBold)!,
                size: 33),
            .foregroundColor: UIColor.color2 // Change this to your desired color
        ]
        
        // Regular title text attributes
            UINavigationBar.appearance().titleTextAttributes = [
                .foregroundColor: UIColor.color2
            ]
    }
    
    var body: some View {
        NavigationView {
            Form {
                sortOrderSection
                filterByGoalSection
            }
            .navigationTitle("Sort and Filter")
            .foregroundColor(.color2)
            .navigationBarItems(trailing: doneButton)
        }
        .onAppear{
            viewModel.setAllGoals(allGoals)
        }
    }
    
    private var sortOrderSection: some View {
        Section(header: Text("Sort")) {
            Picker("Sort Order", selection: $viewModel.sortOrder) {
                ForEach(BookViewModel.SortOrder.allCases, id: \.self) { order in
                    Text(order.rawValue).tag(order)
                }
            }
            .pickerStyle(.inline)
            .labelsHidden()
        }
    }
    
    private var filterByGoalSection: some View {
        Section(header: Text("Filter by Goals")) {
            ForEach(viewModel.allGoals, id: \.self) { goal in
                Button(action: {
                    toggleGoalSelection(goal)
                }) {
                    HStack {
                        Text(goal)
                            .font(.system(size: 17, weight: .regular, design: .default))
                            .foregroundColor(.color1)
                        Spacer()
                        if viewModel.selectedGoals.contains(goal) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            if !viewModel.selectedGoals.isEmpty {
                Button("Clear All", action: clearAllGoals)
                    .foregroundColor(.red)
            }
        }
    }

    private func toggleGoalSelection(_ goal: String) {
        if viewModel.selectedGoals.contains(goal) {
            viewModel.selectedGoals.remove(goal)
        } else {
            viewModel.selectedGoals.insert(goal)
        }
    }
    
    private func clearAllGoals() {
        viewModel.selectedGoals.removeAll()
    }
    
    private var doneButton: some View {
        Button("Done") {
            dismiss()
        }
        .font(.system(size: 17, weight: .bold, design: .default))
        .foregroundColor(.color1)
        
    }
}


struct SortFilterModalView_Previews: PreviewProvider {
    static var previews: some View {
        SortFilterModalView(viewModel: BookViewModel(), allGoals: ["Goal 1", "Goal 2", "Goal 3"])
    }
}
