//
//  AddBookView.swift
//  Leaf
//
//  Created by Diky Nawa Dwi Putra on 26/06/24.
//

import SwiftUI

struct AddBookView: View {
    var body: some View {
            NavigationStack{
                VStack {
                    
                    
                    Text("Add Book View")
                }
                .navigationTitle("Add Book")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                        //todo save
                            }
                            , label: {
                                Text("Save")
                            })
                    }
                }
            }
        }
}

#Preview {
    AddBookView()
}
