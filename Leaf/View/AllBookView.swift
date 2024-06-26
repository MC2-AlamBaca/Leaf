//
//  AllBookView.swift
//  Leaf
//
//  Created by Diky Nawa Dwi Putra on 26/06/24.
//

import SwiftUI

struct AllBookView: View {
    @State private var searchText = ""
       
       var book: [Book]
       
       
       var body: some View {
           NavigationStack {
               ZStack{
                   //if book already exist
                   if !book.isEmpty{
                       //do something if book already exist
                       
                   }else{
                           VStack{
                               Text("AllBookView")
                           }
                           .navigationTitle("Books")
                           .toolbar{
                               ToolbarItem(placement: .topBarTrailing) {
                                   NavigationLink(destination: AddBookView(), label: {
                                       Text("Add Book")
                                   })
                               }
                           }
                           .searchable(text: $searchText)
                   }
               }
           }
       }
}

#Preview {
    AllBookView(book: [])
}
