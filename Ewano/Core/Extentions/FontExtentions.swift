//
//  FontExtentions.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI

extension Font {
    static let svDisplay = Font.custom("BarlowCondensed-Bold", size: 44, relativeTo: .largeTitle)
    static let svHeadlineLg = Font.custom("BarlowCondensed-Bold", size: 34, relativeTo: .title)
    static let svHeadlineMobile = Font.custom("BarlowCondensed-Bold", size: 28, relativeTo: .title2)
    static let svHeadlineMd = Font.custom("BarlowCondensed-SemiBold", size: 26, relativeTo: .title3)
    static let svNumberXl = Font.custom("BarlowCondensed-Bold", size: 56, relativeTo: .largeTitle)
    static let svNumberMd = Font.custom("BarlowCondensed-Bold", size: 24, relativeTo: .title3)

    static let svTitle = Font.custom("SourceSans3-Bold", size: 18, relativeTo: .headline)
    static let svBody = Font.custom("SourceSans3-Medium", size: 16, relativeTo: .body)
    static let svBodySm = Font.custom("SourceSans3-Medium", size: 14, relativeTo: .subheadline)
    static let svLabel = Font.custom("SourceSans3-SemiBold", size: 13, relativeTo: .caption)
    static let svButton = Font.custom("SourceSans3-Bold", size: 17, relativeTo: .headline)
}
