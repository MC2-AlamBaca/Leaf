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
//                        .foregroundColor(.color2)
                }
                Text(note.title)
                    .font(.headline)
                    .fontDesign(.serif)
                    .foregroundColor(.color1)
                    .lineLimit(2)
            }
            Text(note.content)
                .font(.subheadline)
                .foregroundColor(.color2)
                .lineLimit(3)
            HStack {
                if let tags = note.tag, !tags.isEmpty {
                    ForEach(tags.prefix(3), id: \.self) { tag in
                        Text(tag ?? "")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.color1.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                Spacer()
                //                Text(dateFormatter.string(from: note.creationDate))
                //                    .font(.caption)
                //                    .foregroundColor(.secondary)
                Text(dateFormatter.string(from: note.lastModified))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
            }
        }
        .padding(.vertical, 4)
    }
}
