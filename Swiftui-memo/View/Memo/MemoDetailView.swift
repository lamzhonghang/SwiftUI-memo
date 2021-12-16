//
//  MemoDetailView.swift
//  Swiftui-memo
//
//  Created by lan on 2021/11/25.
//

import SwiftUI

struct MemoDetailView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var memos: Memo
    @FocusState private var focusedField: Bool
    @State private var placeholder = "Memo Here"
    @State private var showAlert = false
    
    var body: some View {
        List{
            TextEditor(text: $memos.title.onNone(""))
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
            
            TextField("write by...",text: self.$memos.author.onNone(""))
                .multilineTextAlignment(.trailing)
                .navigationBarItems(trailing: HStack{
                    Button("Save"){
                        try? self.viewContext.save()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                })
            
            Section{
                Button("Delete", role: .destructive){
                    withAnimation {
                        showAlert = true
                    }
                }
                .alert(isPresented: $showAlert){
                    Alert(title: Text("Confirm Deletion"),
                          message: Text("Are you sure you want to delete this memo?"),
                          primaryButton: .destructive(Text("Delete")) {
                        viewContext.delete(memos)
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                        
                        self.presentationMode.wrappedValue.dismiss()
                    },
                          secondaryButton: .cancel())
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}
