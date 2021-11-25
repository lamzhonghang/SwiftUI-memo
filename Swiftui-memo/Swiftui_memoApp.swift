//
//  Swiftui_memoApp.swift
//  Swiftui-memo
//
//  Created by lan on 2021/11/25.
//

import SwiftUI

@main
struct Swiftui_memoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
