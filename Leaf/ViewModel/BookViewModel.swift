import SwiftUI
import SwiftData

class BookViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var sortOrder: SortOrder = .ascending
//    @Published var selectedGoal: String?
    @Published var isShowingSortFilterModal = false
    @Published var selectedGoals: Set<String> = []
    @Published var allGoals: [String] = []
    
    enum SortOrder: String, CaseIterable {
        case ascending = "A-Z"
        case descending = "Z-A"
    }
    
    func setAllGoals(_ goals: [String]) {
            self.allGoals = goals
        }
    
    func filteredBooks(_ books: [Book]) -> [Book] {
            books
                .filter(searchFilter)
                .filter(goalsFilter)
                .sorted(by: sortBooks)
        }
    
    private func searchFilter(_ book: Book) -> Bool {
        searchText.isEmpty || book.title.localizedCaseInsensitiveContains(searchText)
    }
    
    private func goalsFilter(_ book: Book) -> Bool {
            selectedGoals.isEmpty || !selectedGoals.isDisjoint(with: book.goals)
        }
    
    private func sortBooks(_ book1: Book, _ book2: Book) -> Bool {
        let comparison = book1.title.localizedCaseInsensitiveCompare(book2.title)
        return sortOrder == .ascending ? comparison == .orderedAscending : comparison == .orderedDescending
    }
}
