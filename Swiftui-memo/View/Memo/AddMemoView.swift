//
//  AddMemoView.swift
//  Swiftui-memo
//
//  Created by lan on 2021/11/25.
//

import SwiftUI

struct AddNewMemoView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.currentTab) var tab
    
    @State private var title = ""
    @State private var author = ""
    @State private var timestamp = ""
    @FocusState private var focusedField: Bool
    @State private var placeholder = "Memo Here"
    
    
    var body: some View {
        NavigationView {
            List{
                ZStack{
                    if (title.isEmpty) {
                        TextEditor(text:$placeholder)
                            .font(.body)
                            .disabled(true)
                    }
                    //TextEditor with placeholder
                    
                    ZStack (alignment: .topLeading) {
                        TextEditor(text: $title)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .frame(minHeight: 200.0)
                            .focused($focusedField)
                            .foregroundColor(.primary)
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {  /// Anything over 0.5 seems to work
                                    self.focusedField = true
                                }
                            }
                        // Focus on section with cursor
                    }
                }
                .onAppear(perform: {
                    UITextView.appearance().backgroundColor = .clear
                })
                .padding(0)
                .foregroundColor(Color(UIColor.tertiaryLabel))
                
                TextField("Write by ...",text: $author)
                    .multilineTextAlignment(.trailing)
                    .navigationTitle("New Memo")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(leading:HStack{
                        Button("Cancel"){
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }, trailing:HStack{
                        Button("Add"){
                            let newMemo = Memo(context: viewContext)
                            newMemo.title = self.title
                            newMemo.author = self.author
                            newMemo.timestamp = Date()
                            try? self.viewContext.save()
                            tab.wrappedValue = .memo
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    })
            }
        }
    }
}

struct AddNewMemoView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewMemoView()
    }
}

