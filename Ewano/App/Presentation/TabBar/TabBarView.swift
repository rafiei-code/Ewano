//
//  TabBarView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 10/28/26.
//

import SwiftUI

struct TabBarView: View {
    @Bindable var router: SwitchTabRouter
    var tabs: [TabItem] = TabItem.allCases

    @Namespace private var selectionNamespace

    var body: some View {
        TabView(selection: $router.currentTab) {
            ForEach(values: tabs) { tab in
                tab.page
                    .toolbar(.hidden, for: .tabBar)
                    .tag(tab)
            }
        }
        .safeAreaInset(edge: .bottom) {
            tabBar
        }
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
