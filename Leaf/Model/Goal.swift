//
//  Goal.swift
//  Leaf
//
//  Created by Zahratul Wardah on 01/07/24.
//
import SwiftUI
import SwiftData

struct Goal: Identifiable, Hashable {
    let id: UUID
    let title: String
    let imageName: String
    let imgColor: Color
    
    init(title: String, imageName: String, imgColor: Color) {
        self.id = UUID()
        self.title = title
        self.imageName = imageName
        self.imgColor = imgColor
    }
    
}



