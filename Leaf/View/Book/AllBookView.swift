//
//  AllBookView.swift
//  Leaf
//
//  Created by Diky Nawa Dwi Putra on 26/06/24.
//

import SwiftUI
import SwiftData

struct AllBookView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var books: [Book]
    @StateObject private var viewModel = BookViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle).withDesign(.serif)!, size: 48),
            .foregroundColor: UIColor.color1 // Change this to your desired color
        ]
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if let selectedGoal = viewModel.selectedGoal {
                    FilterBadgeView(goal: selectedGoal) {
                        viewModel.selectedGoal = nil
                    }
                }
                if !books.isEmpty{
                    BookListView(books: viewModel.filteredBooks(books))
                }
                else {
                    Text("You have no books yet")
                }
            }
            .navigationTitle("Books")
            .foregroundColor(.color2)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.isShowingSortFilterModal = true
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(.color2)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: AddBookView()) {
                        Image(systemName: "plus")
                            .foregroundColor(.color2)
                    }
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search for Books")
            .sheet(isPresented: $viewModel.isShowingSortFilterModal) {
                SortFilterModalView(viewModel: viewModel, allGoals: Array(Set(books.flatMap { $0.goals })))
            }
        }
    }
}

// Mock Data and ViewModel for Preview
struct AllBookView_Previews: PreviewProvider {
    static var previews: some View {
        AllBookView()
    }
}
