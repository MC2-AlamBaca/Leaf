//
//  Note.swift
//  Leaf
//
//  Created by Marizka Ms on 27/06/24.
//

import Foundation
import SwiftData

@Model
final class Note: Identifiable {
    @Attribute(.unique) let id: UUID
    var title: String
    @Attribute(.externalStorage) var imageNote: Data?
    var page: Int?
    var content: String
    var lastModified: Date
    var prompt: String
    var tag: [String?]?
    var isPinned: Bool
    @Relationship var books: Book?
    var creationDate: Date
    
    init(title: String, imageNote: Data? = nil, page: Int? = nil, content: String, lastModified: Date, prompt: String, tag: [String?]? = nil, isPinned: Bool = false, books: Book?, creationDate: Date) {
        self.id = UUID()
        self.title = title
        self.imageNote = imageNote
        self.page = page
        self.content = content
        self.lastModified = lastModified
        self.prompt = prompt
        self.tag = tag
        self.isPinned = isPinned
        self.books = books
        self.creationDate = creationDate
    }
}

