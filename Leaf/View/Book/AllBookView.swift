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
            .font: UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle)
                .withDesign(.serif)!
                .withSymbolicTraits(.traitBold)!,
                size: 33),
            .foregroundColor: UIColor { traitCollection in
                        switch traitCollection.userInterfaceStyle {
                        case .dark:
                            return UIColor.color2 // Warna untuk dark mode
                        case .light, .unspecified:
                            return UIColor.color1 // Warna untuk light mode
                        @unknown default:
                            return UIColor.color1 // Default fallback
                        }
                    }
        ]
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if !books.isEmpty{
                    BookListView(books: viewModel.filteredBooks(books))
                        .responsiveBadge(goals: Array(viewModel.selectedGoals)) {
                            viewModel.selectedGoals.removeAll()
                        }
                }
                else {
                    Group {
                        Image("emptyStateBook") //Replace "bookCoverBaru" with the name of your image in the assets
                                .resizable()
                                .frame(width: 250, height: 250)
                            Text("No Books yet?\nTap “+” to add one")
                                .font(.system(size: 16))
                                .multilineTextAlignment(.center)
                    }
                }
            }
            .navigationTitle("Books")
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
