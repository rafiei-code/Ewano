//
//  TabBarView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 10/28/26.
//

import SwiftUI

private struct TabBarHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct TabBarView: View {
    @ObservedObject var router: SwitchTabRouter
    var tabs: [TabItem] = TabItem.allCases

    @Namespace private var selectionNamespace
    @State private var tabBarHeight: CGFloat = 0

    private let contentSpacing: CGFloat = 16

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $router.currentTab) {
                ForEach(tabs) { tab in
                    tab.page
                        .safeAreaInset(edge: .bottom, spacing: 0) {
                            Color.clear
                                .frame(height: tabBarHeight + contentSpacing)
                        }
                        .tag(tab)
                }
            }

            tabBar
                .background(
                    GeometryReader { proxy in
                        Color.clear.preference(key: TabBarHeightKey.self, value: proxy.size.height)
                    }
                )
        }
        .onPreferenceChange(TabBarHeightKey.self) { tabBarHeight = $0 }
    }
    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(tabs) { tab in
                TabItemView(
                    tab: tab,
                    isSelected: router.currentTab == tab,
                    selectionNamespace: selectionNamespace
                ) {
                    withAnimation(.spring(duration: 0.35)) {
                        router.currentTab = tab
                    }
                }

                if tab != tabs.last {
                    Spacer(minLength: 0)
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .screenWidth - 40, minHeight: 64)
        .background(.svInverseSurface, in: Capsule())
        .shadow(color: .black.opacity(0.22), radius: 16, y: 12)
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
    }
}

#Preview {
    TabBarView(router: SwitchTabRouter())
}
