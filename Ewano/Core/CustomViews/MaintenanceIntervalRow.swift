//
//  MaintenanceIntervalRow.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import SwiftUI

struct MaintenanceIntervalRow: View {
    let icon: ImageResource
    let title: String
    @Binding var interval: String
    var placeholder: String = ""
    var isRequired: Bool = false

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 12) {
            IconCircleView(icon: icon, diameter: 36, iconSize: 18)

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(title)
                        .font(.svBody)
                        .fontWeight(.semibold)
                        .foregroundStyle(.svOnSurface)
                    if isRequired {
                        Text("*")
                            .font(.svLabel)
                            .foregroundStyle(.svTertiaryContainer)
                            .accessibilityHidden(true)
                    }
                }

                HStack(spacing: 8) {
                    Text("Interval:")
                        .font(.svLabel)
                        .foregroundStyle(.svOnSurfaceVariant)
                        .accessibilityHidden(true)
                    TextField(placeholder, text: $interval)
                        .font(.svBodySm)
                        .fontWeight(.semibold)
                        .foregroundStyle(.svOnSurface)
                        .focused($isFocused)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.svSurfaceLowest, in: RoundedRectangle(cornerRadius: 8))
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(isFocused ? Color.svTertiaryContainer : .svOutlineVariant.opacity(0.6), lineWidth: 2)
                        }
                        .accessibilityLabel(isRequired ? "\(title) interval, required" : "\(title) interval")
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(cornerRadius: 12)
        .animation(.easeOut(duration: 0.15), value: isFocused)
    }
}

#Preview {
    struct Demo: View {
        @State private var oil = ""
        @State private var belt = "Every 90,000 km"

        var body: some View {
            VStack(spacing: 12) {
                MaintenanceIntervalRow(icon: .icOilBarrel, title: "Engine Oil Change", interval: $oil, placeholder: "e.g. Every 5,000 km / 6 mos", isRequired: true)
                MaintenanceIntervalRow(icon: .icTune, title: "Timing Belt Replacement", interval: $belt)
            }
            .padding()
            .background(.svSurface)
        }
    }
    return Demo()
}
