//
//  FilterMenuView.swift
//  Leaf
//
//  Created by Marizka Ms on 30/06/24.
//

import SwiftUI

struct FilterMenuView: View {
    @ObservedObject var viewModel: BookViewModel
    let allGoals: [String]
    
    var body: some View {
        Menu {
            Section("Sort") {
                Button("A-Z") { viewModel.sortOrder = .ascending }
                Button("Z-A") { viewModel.sortOrder = .descending }
            }
            
            Section("Filter by Goal") {
                Button("All Goals") { viewModel.selectedGoal = nil }
                ForEach(allGoals, id: \.self) { goal in
                    Button(goal) { viewModel.selectedGoal = goal }
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
        }
    }
}
