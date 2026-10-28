//
//  ViewExtension.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 10/28/26.
//

import struct SwiftUI.ForEach
import protocol SwiftUI.View

public extension ForEach where Data.Element: Hashable, ID == Data.Element, Content: View {
    init(values: Data, content: @escaping (Data.Element) -> Content) {
        self.init(values, id: \.self, content: content)
    }
}
