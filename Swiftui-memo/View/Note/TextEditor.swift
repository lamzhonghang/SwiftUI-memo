//
//  TextEditor.swift
//  Swiftui-memo
//
//  Created by lan on 2021/11/25.
//

import SwiftUI
import HighlightedTextEditor

//let markdownFileURL =
//    URL(
//        // swiftlint:disable:next line_length
//        string: "https://raw.githubusercontent.com/kyle-n/HighlightedTextEditor/main/Tests/Essayist/iOS-EssayistUITests/MarkdownSample.md"
//    )!
//let markdown = try! String(contentsOf: markdownFileURL, encoding: .utf8)

struct Texteditor: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var notes: Note
    
    
    
//
//    init() {
//        let end = markdown.index(of: "## Blockquotes")!
//        let firstPart = String(markdown.prefix(upTo: end))
//        _text = State<String>(initialValue: firstPart)
//    }

    var body: some View {
        
        HighlightedTextEditor(text: self.$notes.text.onNone(""), highlightRules: .markdown2)
            .frame(maxWidth: 650)

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
