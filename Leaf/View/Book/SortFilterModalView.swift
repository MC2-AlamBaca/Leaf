//
//  SortFilterModalView.swift
//  Leaf
//
//  Created by Marizka Ms on 30/06/24.
//

import SwiftUI

struct SortFilterModalView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: BookViewModel
    let allGoals: [String]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sort")) {
                    Picker("Sort Order", selection: $viewModel.sortOrder) {
                        Text("Ascending").tag(BookViewModel.SortOrder.ascending)
                        Text("Descending").tag(BookViewModel.SortOrder.descending)
                    }
                    .pickerStyle(.inline)
                }
                
                Section(header: Text("Filter by Goal")) {
                    ForEach(["All Goals"] + allGoals, id: \.self) { goal in
                        Button(action: {
                            viewModel.selectedGoal = goal == "All Goals" ? nil : goal
                            dismiss()
                        }) {
                            HStack {
                                Text(goal)
                                Spacer()
                                if goal == "All Goals" ? (viewModel.selectedGoal == nil) : (viewModel.selectedGoal == goal) {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Sort and Filter")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
}

//#Preview {
//    SortFilterModalView(viewModel: <#BookViewModel#>, allGoals: <#[String]#>)
//}
