//
//  TextEditor.swift
//  Swiftui-memo
//
//  Created by lan on 2021/11/25.
//

import SwiftUI
import HighlightedTextEditor

struct Texteditor: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var notes: Note

    var body: some View {
        
        
        HighlightedTextEditor(text: self.$notes.text.onNone(""), highlightRules: .markdown2)
            .frame(maxWidth: 650)
            .lineSpacing(100)
            .padding(.horizontal)
//            .navigationBarTitle("title")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading:
                Button(action : {
                    try? self.viewContext.save()
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Image(systemName: "chevron.backward")
                }
            )
    }
}
//
//struct Texteditor_Previews: PreviewProvider {
//    static var previews: some View {
//        Texteditor(text: "")
//    }
//}
