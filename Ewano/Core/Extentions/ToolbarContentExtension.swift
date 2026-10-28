//
//  ToolbarContentExtension.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import SwiftUI

extension ToolbarContent {
    /// Hides the iOS 26 glass background behind a toolbar item; earlier versions have none.
    @ToolbarContentBuilder
    func hiddenSharedBackground() -> some ToolbarContent {
        if #available(iOS 26.0, *) {
            sharedBackgroundVisibility(.hidden)
        } else {
            self
        }
    }
}
