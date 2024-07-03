//
//  TagInputView.swift
//  Leaf
//
//  Created by Marizka Ms on 28/06/24.
//

import SwiftUI

struct TagInputView: View {
    @Binding var tags: [String]
    @State private var newTag: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(tags, id: \.self) { tag in
                        TagView(tag: tag) {
                            tags.removeAll { $0 == tag }
                        }
                    }
                }
            }
            
            HStack {
                TextField("Add a tag", text: $newTag, onCommit: addTag)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: addTag) {
                    Text("Add")
                }
                .disabled(newTag.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
    
    private func addTag() {
        let tag = newTag.trimmingCharacters(in: .whitespacesAndNewlines)
        if !tag.isEmpty && !tags.contains(tag) {
            tags.append(tag)
            newTag = ""
        }
    }
}

struct TagView: View {
    let tag: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            Text(tag)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.color1.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(15)
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
        }
    }
}
