//
//  IdeaDetailView.swift
//  Swiftui-memo
//
//  Created by lan on 2021/11/25.
//

import SwiftUI

struct IdeaDetailView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var ideas: Idea

    var body: some View {
        List{
            TextField("",text: self.$ideas.title.onNone(""))
            TextField("",text: self.$ideas.subtitle.onNone(""))
                .navigationBarItems(trailing: HStack{
                    Button("Done"){
                        try? self.viewContext.save()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                })
        }
    }
}
