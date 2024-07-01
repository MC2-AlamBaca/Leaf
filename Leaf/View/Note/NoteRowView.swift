//
//  NoteRowView.swift
//  Leaf
//
//  Created by Marizka Ms on 01/07/24.
//

import SwiftUI

struct NoteRowView: View {
    let note: Note
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
//        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if note.isPinned {
                    Image(systemName: "pin.fill")
                        .foregroundColor(.yellow)
                }
                Text(note.title)
                    .font(.headline)
                    .fontDesign(.serif)
                    .lineLimit(2)
            }
            Text(note.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fontDesign(.serif)
                .lineLimit(3)
            HStack {
                if let tags = note.tag, !tags.isEmpty {
                    ForEach(tags.prefix(3), id: \.self) { tag in
                        Text(tag ?? "")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
                Spacer()
                Text(dateFormatter.string(from: note.lastModified))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
            }
        }
        .padding(.vertical, 4)
    }
}
