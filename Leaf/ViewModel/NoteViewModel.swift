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
    @Published var selectedTag: String?
    @Published var isShowingSortFilterModal = false
    @Published var book : Book?
    
    enum SortOrder {
        case ascending, descending
    }
    
    func filteredNotes(_ notes: [Note]) -> [Note] {
        var result = notes
        
        if searchText != "" {
            result = result.filter { note in
                note.title.localizedCaseInsensitiveContains(searchText) ||
                note.content.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let tag = selectedTag {
            //result = result.filter { $0.tag?.contains(tag) == true
            result = result.filter { note in
                note.tag?.contains(tag) ?? false
            }
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
    
    func togglePinNote(_ note: Note) {
        note.isPinned.toggle()
        note.lastModified = Date()
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context after pinning note: \(error.localizedDescription)")
        }
    }
    
    func deleteNote(_ note: Note) {
        modelContext.delete(note)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context after deleting note: \(error.localizedDescription)")
        }
    }
}
