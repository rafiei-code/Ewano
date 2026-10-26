//
//  SelectableCarModelView.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/24.
//

import SwiftUI

struct SelectableCarBrandView: View {
    let carLogo: ImageResource
    let carName: String
    let isSelected: Bool
    var body: some View {
        VStack {
            Image(carLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 55)
                .padding()

            Text(carName)
                .font(.title2)
                .bold()
            Text(isSelected ? "Selected" : "")
                .font(.caption)
                .bold()
                .foregroundStyle(.svOnTertiaryContainer)

        }
        .padding()
        .overlay(alignment: .topTrailing) {
            if isSelected {
                Image(.icCheckCircleFill)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.svOnTertiaryContainer)
                    .frame(width: 34, height: 34)
                    .padding(.trailing, -9)
                    .padding(.top, -8)
            }
        }
    }
}

#Preview {
    SelectableCarBrandView(carLogo:  .logoBmw, carName: "Car", isSelected: true)
}
