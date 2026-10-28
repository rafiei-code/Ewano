//
//  ViewCondition.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 10/28/26.
//

import protocol SwiftUI.View
import struct SwiftUI.ViewBuilder

public extension View {
    /// applys this modifier only if the given condition is true
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, _ transform: @escaping (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
