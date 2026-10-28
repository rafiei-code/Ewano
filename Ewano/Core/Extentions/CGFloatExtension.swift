//
//  CGFloatExtension.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 10/28/26.
//

import Foundation
import UIKit
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGSize

@MainActor
public extension CGFloat {
    static func relativeWidth(_ constant: CGFloat) -> CGFloat {
        (constant / designWidth) * CGFloat.screenWidth
    }

    static func relativeHeight(_ constant: CGFloat) -> CGFloat {
        (constant / designHeight) * CGFloat.screenHeight
    }
}

@MainActor
public extension CGFloat {
    static func relativeWidth(scale: Double) -> CGFloat {
        let screenWidth = CGFloat.screenWidth
        guard scale < 1 else { return screenWidth }
        return scale * screenWidth
    }
    
    static func relativeHeight(scale: Double) -> CGFloat {
        let screenHeight = CGFloat.screenHeight
        guard scale < 1 else { return screenHeight }
        return scale * screenHeight
    }
}

@MainActor
public extension CGSize {
    static func relativeSize(_ constant: CGSize) -> CGSize {
        .init(width: .relativeWidth(constant.width), height: .relativeHeight(constant.height))
    }
}

@MainActor
public extension CGFloat {
    static var screenWidth: CGFloat { windowBounds?.width ?? designWidth }
    static var screenHeight: CGFloat { windowBounds?.height ?? designHeight }

    private static let designWidth: CGFloat = 393
    private static let designHeight: CGFloat = 852

    // Uses the active window's size, which also follows rotation and iPad multitasking.
    private static var windowBounds: CGRect? {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let scene = scenes.first { $0.activationState == .foregroundActive } ?? scenes.first
        return scene?.keyWindow?.bounds ?? scene?.screen.bounds
    }
}
