//
//  Book.swift
//  Leaf
//
//  Created by Marizka Ms on 04/07/24.
//

import Foundation
import SwiftData

@Model
final class Book {
    @Attribute(.unique) let id: UUID
    var title : String
    var author : String
    @Attribute(.externalStorage) var bookCover :Data?
    var goals: [String]
    var isPinned: Bool = false
    
    @Relationship(deleteRule: .cascade) var notes: [Note]? = []
    
    init(title: String, author: String, bookCover: Data? = nil, goals: [String], isPinned: Bool, notes: [Note]? = nil) {
        self.id = UUID()
        self.title = title
        self.author = author
        self.bookCover = bookCover
        self.goals = goals
        self.isPinned = isPinned
        self.notes = notes
    }
    

}
