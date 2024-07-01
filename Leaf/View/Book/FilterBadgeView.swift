//
//  FilterBadgeView.swift
//  Leaf
//
//  Created by Marizka Ms on 30/06/24.
//

import SwiftUI

struct FilterBadgeView: View {
    let goal: String
    let onClear: () -> Void
    
    var body: some View {
        HStack {
            Text("Filtered by goal: \(goal)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Button(action: onClear) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    FilterBadgeView()
//}
