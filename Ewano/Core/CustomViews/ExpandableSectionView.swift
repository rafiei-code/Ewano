//
//  ExpandableSectionView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import SwiftUI

struct ExpandableSectionView: View {

    let car: CarModel
    @State var isExpanded: Bool = false
    var onTapSeeAll: (() -> Void)?


    var body: some View {
        VStack(spacing: 0) {
            header

            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    carCard(car)
                    HStack(spacing: 12) {
                        Text("Coming Up")
                            .font(.svNumberMd)
                            .foregroundStyle(.black)
                        BadgeView(text: "\(car.maintenance.count)", backgroundColor: .svInverseOnSurface)
                        Spacer()
                        CustomButtonView(config: .init(title: "See All", trailingImage: .icChevronRight, titleFont: .svBody, variant: .plain)) {
                            onTapSeeAll?()
                        }
                        .fixedSize()
                    }
                    .padding()
                    schedule
                }
                .padding(.top, 16)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .animation(.easeInOut(duration: 0.3), value: isExpanded)
    }

    private var header: some View {
        Button {
            isExpanded.toggle()
        } label: {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(car.name)
                        .font(.svHeadlineMd)
                        .foregroundStyle(.svOnSurface)
                }

                Image(isExpanded == true ? .icExpandMore : .icChevronRight)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .foregroundStyle(.svOnSurfaceVariant)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .accessibilityHidden(true)
                Spacer(minLength: 8)

            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityValue(isExpanded ? "Expanded" : "Collapsed")
    }

    private func carCard(_ car: CarModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Spacer()
                withAnimation {
                    AppImage(type: .url(car.imageURL))
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .background(.svSurfaceContainer, in: RoundedRectangle(cornerRadius: 16))
                        .accessibilityHidden(true)
                        .frame(minHeight: 100)
                }
                Spacer()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(car.name)
                    .font(.svTitle)
                    .foregroundStyle(.svOnSurface)
                    .lineLimit(1)

                if let maintenance = car.maintenance.first {
                    Text(maintenance.name)
                        .font(.svBodySm)
                        .foregroundStyle(.svOnSurfaceVariant)
                        .lineLimit(1)
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
        .accessibilityElement(children: .combine)
    }

    var schedule: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(car.maintenance.prefix(2), id: \.code) { maintenance in
                ServiceStatusRow(
                    icon: maintenance.serviceIcon,
                    title: maintenance.name,
                    interval: maintenance.serviceInterval,
                    layout: .compact
                )
            }
        }
    }
}
