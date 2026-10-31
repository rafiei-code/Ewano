//
//  TabBarView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 10/28/26.
//

import SwiftUI

struct TabBarView: View {
    @ObservedObject var router: SwitchTabRouter
    let user: User
    let userProfile: ProfileResponse
    let userCars: [CarModel]
    var tabs: [TabItem] = TabItem.allCases

    var body: some View {
        TabView(selection: $router.currentTab) {
            ForEach(tabs) { tab in
                tab.page(for: user, profileResponse: userProfile, userCars: userCars)
                    .tabItem {
                        Label {
                            Text(tab.title)
                        } icon: {
                            Image(tab.icon)
                        }
                    }
                    .tag(tab)
            }
        }
    }
}

//#Preview {
//    TabBarView(router: SwitchTabRouter(), user: .sample)
//}
