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
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if note.isPinned {
                    Image(systemName: "pin.fill")
                        .foregroundColor(.color2)
                }
                
                Text(note.title)
                    .font(.headline)
                    .foregroundStyle(Color("Color 1"))
                    .fontDesign(.serif)
                    .lineLimit(2)
            }
            
            Text(note.content)
                .font(.subheadline)
                .foregroundColor(Color("Color 2"))
                .lineLimit(3)
                .padding(.top, 2)
            
            HStack {
                if let tags = note.tag, !tags.isEmpty {
                    ForEach(tags.prefix(3), id: \.self) { tag in
                        Text(tag ?? "")
                            .font(.footnote)
                            .fontDesign(.serif)
                            .foregroundColor(Color("Color 2"))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(20)
                            .padding(.top, 8)
                    }
                }
                Spacer()
                //                Text(dateFormatter.string(from: note.creationDate))
                //                    .font(.caption)
                //                    .foregroundColor(.secondary)
                Text(dateFormatter.string(from: note.lastModified))
                    .font(.caption)
                    .fontDesign(.serif)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
                
            }
        }
        .padding(.vertical, 4)
    
    }
}
