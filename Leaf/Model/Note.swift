//
//  Note.swift
//  Leaf
//
//  Created by Marizka Ms on 26/06/24.
//

import Foundation
import SwiftData

@Model
class Note {
    @Attribute(.unique) let id: UUID
    var title: String
    var imageNote: String
    var page: Int
    var content: String
    var createdAt: Date
    var prompt: String
    var tag: [String]
    @Relationship(inverse: \Book.notes) var books: [Book]
    
    init( title: String, imageNote: String, page: Int, content: String, createdAt: Date, prompt: String, tag:[String], books: [Book]) {
        self.id = UUID()
        self.title = title
        self.imageNote = imageNote
        self.page = page
        self.content = content
        self.createdAt = createdAt
        self.prompt = prompt
        self.tag = tag
        self.books = books
    }
    
    
}
