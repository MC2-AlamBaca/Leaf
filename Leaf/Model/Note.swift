//
//  Note.swift
//  Leaf
//
//  Created by Marizka Ms on 27/06/24.
//

import Foundation
import SwiftData

@Model
final class Note {
    @Attribute(.unique) let id: UUID
    var title: String
    @Attribute(.externalStorage) var imageNote: Data?
    var page: Int?
    var content: String
    var lastModified: Date
    var prompt: String
    var tag: [String?]?
    @Relationship var books: Book?
    
    init(title: String, imageNote: Data? = nil, page: Int? = nil, content: String, lastModified: Date, prompt: String, tag: [String?]? = nil, books: Book?) {
        self.id = UUID()
        self.title = title
        self.imageNote = imageNote
        self.page = page
        self.content = content
        self.lastModified = lastModified
        self.prompt = prompt
        self.tag = tag
        self.books = books
    }
}

