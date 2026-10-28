//
//  TabItemView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 10/28/26.
//

import SwiftUI

struct TabItemView: View {
    let tab: TabItem
    let isSelected: Bool
    let selectionNamespace: Namespace.ID
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(tab.icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: tab.iconSize, height: tab.iconSize)
                .foregroundStyle(isSelected ? .svOnTertiaryContainer : .svSurfaceLowest)
                .frame(width: 48, height: 48)
                .background {
                    if isSelected {
                        Circle()
                            .fill(.svTertiaryContainer)
                            .matchedGeometryEffect(id: "selection", in: selectionNamespace)
                    }
                }
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tab.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
