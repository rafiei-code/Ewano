//
//  CarModelRowView.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI

struct CarModelOption: Identifiable, Hashable {
    let id: String
    var name: String
    var details: String?
    var image: ImageType?
    var badge: String?
}

struct CarModelRowView: View {
    let option: CarModelOption?
    var isSelected: Bool = false
    var onTap: () -> Void = {}

    var body: some View {
        Group {
            if let option {
                Button(action: onTap) { content(option) }
                    .buttonStyle(.pressable)
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
            } else {
                skeleton
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Loading")
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(cornerRadius: 20)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(isSelected ? Color.svTertiaryContainer : .clear, lineWidth: 2)
        }
        .animation(.easeOut(duration: 0.2), value: isSelected)
    }

    private func content(_ option: CarModelOption) -> some View {
        HStack(spacing: 16) {
            thumbnail(option.image)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(option.name)
                        .font(.svTitle)
                        .foregroundStyle(.svOnSurface)
                    if let badge = option.badge {
                        BadgeView(
                            text: badge.uppercased(),
                            textFont: .svLabel,
                            textColor: .svOnTertiaryFixed,
                            backgroundColor: .svTertiaryFixed,
                            verticalPadding: 3,
                            horizontalPadding: 8
                        )
                    }
                }
                if let details = option.details {
                    Text(details)
                        .font(.svBodySm)
                        .foregroundStyle(.svOnSurfaceVariant)
                        .lineLimit(1)
                }
            }

            Spacer(minLength: 8)
            SelectionDot(isSelected: isSelected)
        }
        .contentShape(Rectangle())
    }

    private func thumbnail(_ image: ImageType?) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.svSurfaceLow)
            .frame(width: 96, height: 64)
            .overlay {
                if let image {
                    AppImage(type: image)
                        .padding(6)
                } else {
                    Image(.icDirectionsCar)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundStyle(.svOutline)
                }
            }
            .accessibilityHidden(true)
    }

    private var skeleton: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 12)
                .fill(.svSurfaceHigh)
                .frame(width: 96, height: 64)

            VStack(alignment: .leading, spacing: 10) {
                Capsule().fill(.svSurfaceHigh).frame(width: 100, height: 16)
                Capsule().fill(.svSurfaceHigh).frame(width: 170, height: 12)
            }

            Spacer(minLength: 8)
            Circle().fill(.svSurfaceHigh).frame(width: 32, height: 32)
        }
        .shimmer()
    }
}

#Preview("Car model rows") {
    struct Demo: View {
        @State private var selected = "camry"
        @State private var isLoading = false

        let items: [CarModelOption] = [
            .init(id: "camry", name: "Camry", details: "Sedan • 2.5L Dynamic Force", image: nil, badge: "Match"),
            .init(id: "corolla", name: "Corolla", details: "Compact Sedan • 2.0L FWD", image: nil),
            .init(id: "rav4", name: "RAV4", details: "Compact SUV • Hybrid AWD", image: nil)
        ]

        var body: some View {
            ScrollView {
                VStack(spacing: 16) {
                    Toggle("Loading", isOn: $isLoading)

                    if isLoading {
                        ForEach(0..<4, id: \.self) { _ in CarModelRowView(option: nil) }
                    } else {
                        ForEach(items) { item in
                            CarModelRowView(option: item, isSelected: selected == item.id) {
                                selected = item.id
                            }
                        }
                    }
                }
                .padding(16)
            }
        }
    }
    return Demo()
}
