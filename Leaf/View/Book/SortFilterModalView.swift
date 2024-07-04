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
                
                
                Section(header: Text("Sort") .foregroundColor(.color2)) {
                    Picker("Sort Order", selection: $viewModel.sortOrder) {
                        Text("Ascending").foregroundColor(.color2).tag(BookViewModel.SortOrder.ascending)
                        Text("Descending").foregroundColor(.color2).tag(BookViewModel.SortOrder.descending)
                    }
                    .pickerStyle(.inline)
                    .accentColor(Color.color2)
                    
                }
                
//                Section(header: Text("Sort").foregroundColor(.color2)) {
//                                   CustomPicker(selection: $viewModel.sortOrder, options: [.ascending, .descending], label: "Sort Order")
//                               }
                
                Section(header: Text("Filter by Goal") .foregroundColor(.color2)) {
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
        .foregroundColor(.color2)
    }
}
//
//// Define the CustomPicker view
//struct CustomPicker: View {
//    @Binding var selection: BookViewModel.SortOrder
//    var options: [BookViewModel.SortOrder]
//    var label: String
//    
//    var body: some View {
//        VStack(alignment: .leading) {
////            Text(label)
////                .foregroundColor(.color2)
//            ForEach(options, id: \.self) { option in
//                HStack {
//                    Text(option == .ascending ? "Ascending" : "Descending")
//                        .foregroundColor(.color2) // Change text color here
//                    Spacer()
//                    if option == selection {
//                        Image(systemName: "checkmark")
//                            .foregroundColor(.color2) // Change checkmark color here
//                    }
//                }
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    selection = option
//                }
//            }
//        }
//    }
//}

//#Preview {
//    SortFilterModalView(viewModel: <#BookViewModel#>, allGoals: <#[String]#>)
//}
