//
//  SortFilterNoteModal.swift
//  Leaf
//
//  Created by Marizka Ms on 01/07/24.
//

import SwiftUI

import SwiftUI

struct SortFilterNoteModalView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: NoteViewModel
    let allTags: [String]
    
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
                
                Section(header: Text("Filter by Tag")) {
                    ForEach(["All Tags"] + allTags, id: \.self) { tag in
                        Button(action: {
                            viewModel.selectedTag = tag == "All Goals" ? nil : tag
                            dismiss()
                        }) {
                            HStack {
                                Text(tag)
                                Spacer()
                                if tag == "All Tags" ? (viewModel.selectedTag == nil) : (viewModel.selectedTag == tag) {
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


//#Preview {
//    SortFilterNoteModalView(viewModel: <#NoteViewModel#>, allTags: <#[String]#>)
//}
