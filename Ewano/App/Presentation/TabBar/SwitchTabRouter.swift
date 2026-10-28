//
//  SwitchTabRouter.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 10/28/26.
//

import Observation

@Observable
final public class SwitchTabRouter {
    static let shared = SwitchTabRouter()

    var currentTab: TabItem = .home
}
