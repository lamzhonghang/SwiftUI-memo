//
//  binding + optional fallback.swift
//  Swiftui-memo
//
//  Created by lan on 2021/11/25.
//

import SwiftUI

extension Binding where Value == String? {
    func onNone(_ fallback: String) -> Binding<String> {
        return Binding<String>(get: {
            return self.wrappedValue ?? fallback
        }) { value in
            self.wrappedValue = value
        }
    }
}
