//
//  SelectableCarBrandView.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/24.
//

import SwiftUI

struct SelectableCarBrandView: View {
    let logo: ImageType
    let name: String
    let isSelected: Bool
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                AppImage(type: logo)
                    .frame(width: 40, height: 40)
                    .frame(width: 48, height: 48)
                    .padding(.bottom, 10)

                Text(name)
                    .font(.svBody)
                    .fontWeight(.semibold)
                    .foregroundStyle(.svOnSurface)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                Text("Selected")
                    .font(.svLabel)
                    .bold()
                    .foregroundStyle(.svTertiary)
                    .opacity(isSelected ? 1 : 0)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity)
            .background(.svSurfaceLowest, in: RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(isSelected ? Color.svTertiaryContainer : .clear, lineWidth: 2)
            }
            .overlay(alignment: .topTrailing) {
                if isSelected {
                    Image(.icCheck)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                        .foregroundStyle(.svOnTertiaryContainer)
                        .frame(width: 20, height: 20)
                        .background(.svTertiaryContainer, in: Circle())
                        .padding(8)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .shadow(color: .black.opacity(isSelected ? 0.1 : 0.05), radius: isSelected ? 6 : 2, y: isSelected ? 3 : 1)
            .animation(.easeOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(.pressable)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(name)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
}

#Preview {
    HStack(spacing: 12) {
        SelectableCarBrandView(logo: .local(.logoToyota), name: "Toyota", isSelected: true)
        SelectableCarBrandView(logo: .local(.logoBmw), name: "BMW", isSelected: false)
        SelectableCarBrandView(logo: .local(.logoMercedes), name: "Mercedes-Benz", isSelected: false)
    }
    .padding()
    .background(.svSurface)
}
