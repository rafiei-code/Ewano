//
//  FontExtentions.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI
import CoreText

extension Font {
    // Register lazily so bundled fonts also render in standalone view previews.
    private static let registerBundledFonts: Void = {
        let names = [
            "BarlowCondensed-Bold", "BarlowCondensed-SemiBold",
            "SourceSans3-Bold", "SourceSans3-SemiBold", "SourceSans3-Medium"
        ]
        for name in names {
            if let url = Bundle.main.url(forResource: name, withExtension: "ttf") {
                CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
            }
        }
    }()

    private static func registeredCustom(_ name: String, size: CGFloat, relativeTo style: Font.TextStyle) -> Font {
        _ = registerBundledFonts
        return Font.custom(name, size: size, relativeTo: style)
    }

    static let svDisplay = registeredCustom("BarlowCondensed-Bold", size: 44, relativeTo: .largeTitle)
    static let svHeadlineLg = registeredCustom("BarlowCondensed-Bold", size: 34, relativeTo: .title)
    static let svHeadlineMobile = registeredCustom("BarlowCondensed-Bold", size: 28, relativeTo: .title2)
    static let svHeadlineMd = registeredCustom("BarlowCondensed-SemiBold", size: 26, relativeTo: .title3)
    static let svNumberXl = registeredCustom("BarlowCondensed-Bold", size: 56, relativeTo: .largeTitle)
    static let svNumberMd = registeredCustom("BarlowCondensed-Bold", size: 24, relativeTo: .title3)
    static let svBrandMark = registeredCustom("BarlowCondensed-SemiBold", size: 16, relativeTo: .callout)

    static let svTitle = registeredCustom("SourceSans3-Bold", size: 18, relativeTo: .headline)
    static let svBody = registeredCustom("SourceSans3-Medium", size: 16, relativeTo: .body)
    static let svBodySm = registeredCustom("SourceSans3-Medium", size: 14, relativeTo: .subheadline)
    static let svLabel = registeredCustom("SourceSans3-SemiBold", size: 13, relativeTo: .caption)
    static let svButton = registeredCustom("SourceSans3-Bold", size: 17, relativeTo: .headline)
}
