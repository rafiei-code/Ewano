//
//  UnderlineTabBar.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import SwiftUI

struct UnderlineTabBar<Item: Hashable>: View {
    let items: [Item]
    @Binding var selection: Item
    let title: (Item) -> String

    @Namespace private var underlineNamespace

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 16) {
                ForEach(items, id: \.self) { item in
                    tab(item)
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    private func tab(_ item: Item) -> some View {
        let isSelected = item == selection

        return Button {
            withAnimation(.snappy(duration: 0.25)) { selection = item }
        } label: {
            Text(title(item))
                .font(.svBody)
                .fontWeight(isSelected ? .bold : .semibold)
                .foregroundStyle(isSelected ? .svOnSurface : .svOutline)
                .padding(.bottom, 8)
                .overlay(alignment: .bottom) {
                    if isSelected {
                        Capsule()
                            .fill(.svTertiaryContainer)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "underline", in: underlineNamespace)
                    }
                }
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    @Previewable @State var selection = "All (12)"
    UnderlineTabBar(items: ["All (12)", "Overdue (1)", "Due Soon (2)", "OK (9)"], selection: $selection) { $0 }
        .padding()
        .background(.svSurface)
}
