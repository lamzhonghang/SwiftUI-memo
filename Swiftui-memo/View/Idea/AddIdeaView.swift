//
//  AddIdeaView.swift
//  Swiftui-memo
//
//  Created by lan on 2021/11/25.
//

import SwiftUI

struct AddIdeaView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.currentTab) var tab
    
    @State private var title = ""
    @State private var subtitle = ""
    @State private var timestamp = ""
    
    
    var body: some View {
        NavigationView {
            List{
                TextField("Ideas", text: $title)
                TextField("Description",text: $subtitle)
                    .navigationTitle("New Ideas")
                    .navigationBarItems(leading:HStack{
                        Button("Cancel"){
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }, trailing:HStack{
                        Button("Add"){
                            let newIdea = Idea(context: viewContext)
                            newIdea.title = self.title
                            newIdea.subtitle = self.subtitle
                            newIdea.timestamp = Date()
                            try? self.viewContext.save()
                            tab.wrappedValue = .idea
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    })
            }
        }
    }
}

struct AddNewIdeasView_Previews: PreviewProvider {
    static var previews: some View {
        AddIdeaView()
    }
}
