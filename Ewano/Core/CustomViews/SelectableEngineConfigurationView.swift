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

    var body: some View {
        HStack(spacing: 12) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
                .padding()
                .background {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.svTertiaryFixed)
                    }
                }
                .padding()

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.svHeadlineMobile)
                    .foregroundStyle(.svOnSurface)

                Text(description)
                    .font(.svBodySm)
                    .foregroundStyle(.svOnSurfaceVariant)
            }

            Spacer(minLength: 0)

            if isSelected {
                Image(.icCheckCircleFill)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.svTertiaryContainer)
                    .frame(width: 44, height: 44)
                    .padding()
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    isSelected
                        ? Color.svTertiaryContainer
                        : Color.clear,
                    lineWidth: 1
                )
        }
        .contentShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    SelectableEngineConfigurationView(
        title: "Engine A",
        description: "Engine description",
        icon: .icLocalGasStationFill,
        isSelected: true
    )
}
