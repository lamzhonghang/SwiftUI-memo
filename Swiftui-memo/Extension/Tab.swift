//
//  Tab.swift
//  Swiftui-memo
//
//  Created by lan on 2021/11/25.
//

import SwiftUI

struct CurrentTabKey: EnvironmentKey {
    static var defaultValue: Binding<ContentView.Tab> = .constant(.idea)
}

extension EnvironmentValues {
    var currentTab: Binding<ContentView.Tab> {
        get { self[CurrentTabKey.self] }
        set { self[CurrentTabKey.self] = newValue }
    }
}
