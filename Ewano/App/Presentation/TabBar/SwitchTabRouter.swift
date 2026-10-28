//
//  SwitchTabRouter.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 10/28/26.
//

import Combine

final public class SwitchTabRouter: ObservableObject {
    static let shared = SwitchTabRouter()

    @Published var currentTab: TabItem = .home
}
