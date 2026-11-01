//
//  SelectableEngineConfigurationView.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//


import SwiftUI

struct SelectableEngineConfigurationView: View {

    let title: String
    let description: String
    let icon: ImageResource
    let isSelected: Bool
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                Image(icon)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(isSelected ? .svOnTertiaryFixed : .svOnSurfaceVariant)
                    .frame(width: 40, height: 40)
                    .background(isSelected ? Color.svTertiaryFixed : .svSurfaceHigh, in: RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.svTitle)
                        .foregroundStyle(.svOnSurface)
                        .multilineTextAlignment(.leading)

                    Text(description)
                        .font(.svBodySm)
                        .foregroundStyle(.svOnSurfaceVariant)
                }

                Spacer(minLength: 8)

                if isSelected {
                    Image(.icCheck)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.svOnTertiaryContainer)
                        .frame(width: 28, height: 28)
                        .background(.svTertiaryContainer, in: Circle())
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.svSurfaceLowest, in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(isSelected ? Color.svTertiaryContainer : .clear, lineWidth: 2)
            }
            .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
            .contentShape(RoundedRectangle(cornerRadius: 12))
            .animation(.easeOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(.pressable)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    VStack(spacing: 8) {
        SelectableEngineConfigurationView(
            title: "2.5L 4-Cyl Petrol",
            description: "Petrol",
            icon: .icLocalGasStationFill,
            isSelected: true
        )
        SelectableEngineConfigurationView(
            title: "2.5L Hybrid",
            description: "Hybrid",
            icon: .icElectricBoltFill,
            isSelected: false
        )
    }
    .padding()
    .background(.svSurface)
}
