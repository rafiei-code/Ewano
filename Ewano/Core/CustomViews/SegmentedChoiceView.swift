//
//  SegmentedChoiceView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import SwiftUI

struct SegmentedChoiceView<Option: Hashable>: View {
    enum Size {
        case regular
        case compact
    }

    let options: [Option]
    @Binding var selection: Option
    var size: Size = .regular
    let title: (Option) -> String

    var body: some View {
        HStack(spacing: size == .regular ? 6 : 2) {
            ForEach(options, id: \.self) { option in
                segment(option)
            }
        }
        .padding(size == .regular ? 6 : 2)
        .background(size == .regular ? Color.svSurfaceLow : .svSurfaceContainer, in: shape)
        .animation(.easeOut(duration: 0.2), value: selection)
    }

    private var shape: some Shape {
        RoundedRectangle(cornerRadius: size == .regular ? 12 : 20)
    }

    private func segment(_ option: Option) -> some View {
        let isSelected = option == selection
        return Button {
            selection = option
        } label: {
            Text(title(option))
                .font(size == .regular ? .svButton : .svLabel)
                .foregroundStyle(isSelected ? .svOnTertiaryContainer : .svOnSurfaceVariant)
                .frame(maxWidth: size == .regular ? .infinity : nil)
                .padding(.horizontal, 12)
                .frame(height: size == .regular ? 48 : 26)
                .background {
                    RoundedRectangle(cornerRadius: size == .regular ? 8 : 13)
                        .fill(isSelected ? Color.svTertiaryContainer : size == .regular ? .svSurfaceLowest : .clear)
                        .shadow(color: .black.opacity(isSelected ? 0.08 : 0), radius: 2, y: 1)
                }
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    struct Demo: View {
        @State private var transmission = NewCarSelection.Transmission.automatic
        @State private var unit = DistanceUnit.kilometers

        var body: some View {
            VStack(spacing: 24) {
                SegmentedChoiceView(options: NewCarSelection.Transmission.allCases, selection: $transmission) { $0.rawValue }
                SegmentedChoiceView(options: [.kilometers, .miles], selection: $unit, size: .compact) { $0.symbol }
            }
            .padding()
            .background(.svSurface)
        }
    }
    return Demo()
}
