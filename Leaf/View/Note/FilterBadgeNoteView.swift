//
//  FilterBadgeNoteView.swift
//  Leaf
//
//  Created by Marizka Ms on 04/07/24.
//

import SwiftUI

struct FilterBadgeNoteView: View {
    let tags: [String]
    let onClear: () -> Void
    
    var body: some View {
        HStack {
            Text("Filtered by tags: \(tags.joined(separator: ", "))")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .truncationMode(.tail)
            Spacer()
            Button(action: onClear) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal)
    }
}

struct ResponsiveBadgeNoteModifier: ViewModifier {
    let tags: [String]
    let onClear: () -> Void
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            if !tags.isEmpty {
                FilterBadgeNoteView(tags: tags, onClear: onClear)
                    .padding(.vertical, 8)
                    .background(Color(UIColor.secondarySystemBackground))
            }
            content
        }
    }
}

extension View {
    func responsiveNoteBadge(tags: [String], onClear: @escaping () -> Void) -> some View {
        self.modifier(ResponsiveBadgeNoteModifier(tags: tags, onClear: onClear))
    }
}

//#Preview {
//    FilterBadgeNoteView()
//}
