//
//  GarageView.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/28.
//

import SwiftUI
import Lottie

struct GarageView: View {

    let user: User
    let userProfile: ProfileResponse
    let cars: [CarModel]
    var onTapNotification: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            AppScreenHeaderView(user: userProfile, onTapProfile: {
                SwitchTabRouter.shared.currentTab = .more
            }, onTapNotification: {
            })
            ScrollView {
                HStack {
                    VStack(spacing: 4) {
                        HStack(spacing: 4) {
                            Text("MY GARAGE")
                                .font(.svHeadlineMobile)
                                .foregroundStyle(.black)

                            LottieView(animation: .loginStar)
                                .playing(loopMode: .loop)
                                .frame(width: 32, height: 32)
                                .accessibilityHidden(true)
                            Spacer()

                        }
                        HStack(spacing: 4) {
                            Text("\(cars.count) vehicles registered")
                                .font(.caption)
                                .foregroundStyle(.black)

                            Circle()
                                .frame(height: 4)
                                .foregroundStyle(.svOutline)

                            Text("Fleet health: \(calculateFleetHealth()) %")
                                .font(.svBody)
                                .foregroundStyle(.svOnTertiaryContainer)
                            Spacer()
                        }
                    }
                    CustomButtonView(config: .init(leadingImage: .icAdd, leadingImageSize: 24, iconColor: .black, variant: .filled, shape: .circle), action: {
                        onTapNotification?()
                    })
                    .fixedSize()
                }
                .padding()

                ForEach(cars, id: \.id) { car in
                    VehicleHealthCard(
                        car: car
                    ) {
                        SwitchTabRouter.shared.showSchedule(for: car)
                    }
                    .padding()
                }

                CustomButtonView(config: .init(leadingImage: .icAddCircle, leadingImageSize: 24, iconColor: .svOnSurfaceVariant, backgroundColor: .svOnSurfaceVariant.opacity(0.4), variant: .filled, shape: .circle), action: {
                    onTapNotification?()
                })
                .fixedSize()
                .padding(.top, 24)

                Text("Add Another Car")
                    .font(.svTitle)
                    .foregroundStyle(.black)

                Text("""
Track Maintenance intervals, parts
 warranty, and service log for your entire
 garage.
""")
                .multilineTextAlignment(.center)

                CustomButtonView(
                    config: .init(
                        title: "Add Vehicle",
                        leadingImage: .icDirectionsCar,
                        leadingImageSize: 24,
                        titleColor: .black,
                        titleFont: .svTitle,
                        iconColor: .black,
                        backgroundColor: .svOnSurfaceVariant.opacity(0.4),
                        variant: .filled,
                        shape: .square
                    ), action: {
                        onTapNotification?()
                    })
                .fixedSize()

            }
        }
        .background(.svSurfaceHigh)
        .navigationBarBackButtonHidden(true)
    }

    func calculateFleetHealth() -> Int {
        let remainingFractions = cars
            .flatMap(\.maintenance)
            .filter { $0.serviceStatus != nil }
            .map { min(max(1 - $0.elapsedFraction, 0), 1) }

        guard !remainingFractions.isEmpty else { return 0 }

        let average = remainingFractions.reduce(0, +) / Double(remainingFractions.count)
        return Int((average * 100).rounded())
    }
}

#Preview {
    GarageView(user: .sample, userProfile: .sample, cars: CarModel.samples)
}
