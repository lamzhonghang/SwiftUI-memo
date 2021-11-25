//
//  TextEditor.swift
//  Swiftui-memo
//
//  Created by lan on 2021/11/25.
//

import SwiftUI

struct Texteditor: View {
    @State private var fullText: String = "This is some editable text..."
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        
            TextEditor(text: $fullText)
                .padding()
    }
}

struct Texteditor_Previews: PreviewProvider {
    static var previews: some View {
        Texteditor()
    }
}
