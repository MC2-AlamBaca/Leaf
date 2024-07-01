//
//  BookViewModel.swift
//  Leaf
//
//  Created by Marizka Ms on 30/06/24.
//

import SwiftUI
import SwiftData

class BookViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var sortOrder: SortOrder = .ascending
    @Published var selectedGoal: String?
    @Published var isShowingSortFilterModal = false
    
    enum SortOrder {
        case ascending, descending
    }
    
    func filteredBooks(_ books: [Book]) -> [Book] {
        var result = books
        
        if !searchText.isEmpty {
            result = result.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        
        if let goal = selectedGoal {
            result = result.filter { $0.goals.contains(goal) }
        }
        
        result.sort {
            switch sortOrder {
            case .ascending:
                return $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            case .descending:
                return $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedDescending
            }
        }
        
        return result
    }
}
