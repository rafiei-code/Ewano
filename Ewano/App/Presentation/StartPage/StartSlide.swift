//
//  StartSlide.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI

struct StartSlide: Identifiable {
    let id: Int
    let image: ImageResource
    let tag: String
    let title: String
    let description: String

    static let all: [StartSlide] = [
        StartSlide(
            id: 0,
            image: .imgStartHero,
            tag: "Intelligent vehicle care",
            title: "NEVER MISS A\nSERVICE AGAIN.",
            description: "Add your car, enter your mileage, and we'll tell you what's due next."
        ),
        StartSlide(
            id: 1,
            image: .imgStartPredictions,
            tag: "Smart predictions",
            title: "KNOW WHAT'S DUE\nBEFORE IT'S DUE.",
            description: "We match your car's factory schedule to your real mileage and driving habits, so every oil change and inspection shows up weeks ahead."
        ),
        StartSlide(
            id: 2,
            image: .imgStartGarage,
            tag: "Complete garage",
            title: "EVERY CAR.\nEVERY RECORD.",
            description: "Keep all your vehicles, service records and receipts in one garage, with a full history ready for the next shop visit or sale."
        )
    ]
}
