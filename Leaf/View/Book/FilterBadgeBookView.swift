//
//  FilterBadgeView.swift
//  Leaf
//
//  Created by Marizka Ms on 30/06/24.
//

import SwiftUI

struct FilterBadgeBookView: View {
    let goals: [String]
    let onClear: () -> Void
    
    var body: some View {
        HStack {
            Text("Filtered by goals: \(goals.joined(separator: ", "))")
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
        .background(.clear)
    }
}

struct ResponsiveBadgeModifier: ViewModifier {
    let goals: [String]
    let onClear: () -> Void
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            if !goals.isEmpty {
                FilterBadgeBookView(goals: goals, onClear: onClear)
                    .padding(.vertical, 8)
                    .background(Color(UIColor.secondarySystemBackground))
            }
            content
        }
    }
}

extension View {
    func responsiveBadge(goals: [String], onClear: @escaping () -> Void) -> some View {
        self.modifier(ResponsiveBadgeModifier(goals: goals, onClear: onClear))
    }
}
//#Preview {
//    FilterBadgeView()
//}
