//
//  Book.swift
//  Leaf
//
//  Created by Diky Nawa Dwi Putra on 26/06/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class Book {
    var uuid : String = UUID().uuidString
    var title : String
    var author : String
    var bookCover : Data?
    var goal : [String]
    
    init(title: String, author: String, bookCover: Data? = nil, goal: [String]) {
        self.title = title
        self.author = author
        self.bookCover = bookCover
        self.goal = goal
    }
}
