//
//  ContentView.swift
//  Swiftui-memo
//
//  Created by lan on 2021/11/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    enum Tab{
        case note
        case memo
        case idea
        case count
    }
    
    @State private var selection:Tab = .memo
    
    var body: some View{
        TabView(selection: $selection) {
            
            NoteView().tabItem {
                Image(systemName: "rectangle.portrait")
                Text("note")
            }.tag(Tab.note)
                .environment(\.currentTab, $selection)
            
            MemoView().tabItem {
                Image(systemName: "rectangle")
                Text("memo")
            }.tag(Tab.memo)
            .environment(\.currentTab, $selection)
            
            IdeaView().tabItem {
                Image(systemName: "circle")
                Text("ideas")
            }.tag(Tab.idea)
            .environment(\.currentTab, $selection)
            
            IdeaView().tabItem {
                Image(systemName: "square")
                Text("count")
            }.tag(Tab.count)
                .environment(\.currentTab, $selection)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
