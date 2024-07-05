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
    
    func filteredAndSortedNotes(_ notes: [Note]) -> [Note] {
        var result = notes
        
        //search filter
        if searchText != "" {
            result = result.filter { note in
                note.title.localizedCaseInsensitiveContains(searchText) ||
                note.content.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        //apply tag filter
        if let tag = selectedTag {
            //result = result.filter { $0.tag?.contains(tag) == true
            result = result.filter { note in
                note.tag?.contains(tag) ?? false
            }
        }
        
        //Sort notes: pinned first, then by title
        result.sort { note1, note2 in
            if note1.isPinned != note2.isPinned {
                return note1.isPinned && !note2.isPinned
            } else {
                switch sortOrder {
                case .ascending:
                    return note1.title.localizedCaseInsensitiveCompare(note2.title) == .orderedAscending
                case .descending:
                    return note1.title.localizedCaseInsensitiveCompare(note2.title) == .orderedDescending
                }
            }
        }
        return result
    }
    
//    func fetchNoteByID(_ id: UUID) -> Note? {
//            let request = NSFetchRequest<Note>(entityName: "Note")
//            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//            do {
//                let notes = try modelContext.fetch(request)
//                return notes.first
//            } catch {
//                print("Failed to fetch note: \(error.localizedDescription)")
//                return nil
//            }
//        }

}
