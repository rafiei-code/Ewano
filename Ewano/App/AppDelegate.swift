//
//  AppDelegate.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/31.
//

import Foundation

import SwiftUI
import netfox   // module name may be NFX depending on version

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        NFX.sharedInstance().start()
        return true
    }
}
