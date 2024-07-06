//
//  NoteViewModel.swift
//  Leaf
//
//  Created by Marizka Ms on 01/07/24.
//


import SwiftUI
import SwiftData

class NoteViewModel: ObservableObject {
    @Environment(\.modelContext) private var modelContext
    @Published var searchText = ""
    @Published var sortOrder: SortOrder = .ascending
    @Published var sortOrderTime: SortOrderTime = .modifiedDateAscending
    @Published var isShowingSortFilterModal = false
    @Published var book: Book?
    @Published var selectedTags: Set<String> = []
    @Published var allTags: [String] = []
    @Published var selectedNote: Note?

    enum SortOrder: String, CaseIterable {
        case ascending = "A-Z"
        case descending = "Z-A"
    }
    
    enum SortOrderTime: String, CaseIterable {
        case modifiedDateAscending = "Modified Date A-Z"
        case modifiedDateDescending = "Modified Date Z-A"
    }
    

    

    func setAllTags(_ tags: [String]) {
        self.allTags = tags
    }

    func filteredAndSortedNotes(_ notes: [Note]) -> [Note] {
        notes
            .filter(searchFilter)
            .filter(tagsFilter)
            .sorted(by: sortNotes)
    }

    private func searchFilter(_ note: Note) -> Bool {
        guard !searchText.isEmpty else { return true }
        return note.title.localizedCaseInsensitiveContains(searchText) ||
               note.content.localizedCaseInsensitiveContains(searchText)
    }

    private func tagsFilter(_ note: Note) -> Bool {
        guard !selectedTags.isEmpty else { return true }
        guard let noteTags = note.tag else { return false }
        
        let result = selectedTags.contains { selectedTag in
            noteTags.contains(selectedTag)
        }
        
        print("Note: \(note.title), Tags: \(noteTags), SelectedTags: \(selectedTags), Pass: \(result)")
        return result
    }
    
    
    private func sortNotes(_ note1: Note, _ note2: Note) -> Bool {
        if note1.isPinned != note2.isPinned {
            return note1.isPinned && !note2.isPinned
        } else {
            let comparison = note1.title.localizedCaseInsensitiveCompare(note2.title)
            return sortOrder == .ascending ? comparison == .orderedAscending : comparison == .orderedDescending
        }
    }
    
    
    private func sortNotesTime(_ note1: Note, _ note2: Note) -> Bool {
        if note1.isPinned != note2.isPinned {
            return note1.isPinned && !note2.isPinned
        } else {
            switch sortOrderTime {
            case .modifiedDateAscending:
                return note1.lastModified < note2.lastModified
            case .modifiedDateDescending:
                return note1.lastModified > note2.lastModified
            }
        }
    }
    
}
