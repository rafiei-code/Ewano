//
//  ServiceMileageRow.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/11/01.
//

import SwiftUI

/// A service with its interval and the odometer reading it was last done at.
struct ServiceMileageRow: View {
    let icon: ImageResource
    let title: String
    let interval: String
    @Binding var lastServiceKM: String
    var placeholder: String = ""
    var unitSymbol: String = "km"
    var isRequired: Bool = false
    var errorMessage: String?

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            IconCircleView(icon: icon, diameter: 36, iconSize: 18)

            VStack(alignment: .leading, spacing: 6) {
                VStack(alignment: .leading, spacing: 2) {
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
                    Text(interval)
                        .font(.svLabel)
                        .foregroundStyle(.svOnSurfaceVariant)
                }

                HStack(spacing: 8) {
                    Text("Last service at:")
                        .font(.svLabel)
                        .foregroundStyle(.svOnSurfaceVariant)
                        .accessibilityHidden(true)
                    HStack(spacing: 6) {
                        TextField(placeholder, text: $lastServiceKM)
                            .font(.svBodySm)
                            .fontWeight(.semibold)
                            .foregroundStyle(.svOnSurface)
                            .keyboardType(.numberPad)
                            .focused($isFocused)
                            .accessibilityLabel("\(title), last service at, \(unitSymbol)")
                        Text(unitSymbol.uppercased())
                            .font(.svLabel)
                            .bold()
                            .foregroundStyle(.svOnSurfaceVariant)
                            .accessibilityHidden(true)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.svSurfaceLowest, in: RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(borderColor, lineWidth: 2)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { isFocused = true }
                }

                if let errorMessage {
                    Text(errorMessage)
                        .font(.svLabel)
                        .foregroundStyle(.svError)
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(cornerRadius: 12)
        .animation(.easeOut(duration: 0.15), value: isFocused)
        .animation(.easeOut(duration: 0.15), value: errorMessage)
    }

    private var borderColor: Color {
        if errorMessage != nil { return .svError }
        return isFocused ? .svTertiaryContainer : .svOutlineVariant.opacity(0.6)
    }
}

#Preview {
    struct Demo: View {
        @State private var oil = "45000"
        @State private var belt = ""

        var body: some View {
            VStack(spacing: 12) {
                ServiceMileageRow(icon: .icOilBarrel, title: "Engine Oil Change", interval: "Every 5,000 km / 6 mos", lastServiceKM: $oil, isRequired: true)
                ServiceMileageRow(icon: .icTune, title: "Timing Belt Replacement", interval: "Every 90,000 km / 60 mos", lastServiceKM: $belt, placeholder: "48,250")
                ServiceMileageRow(icon: .icAir, title: "Air Filter", interval: "Every 20,000 km", lastServiceKM: .constant("60000"), errorMessage: "Can't be more than the current odometer")
            }
            .padding()
            .background(.svSurface)
        }
    }
    return Demo()
}
