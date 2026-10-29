//
//  HomeView.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/27.
//

import SwiftUI
import Lottie

struct HomeView: View {

    let user: UserModel
    var onTapProfile: (() -> Void)?
    var onTapNotification: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            appHeader
            ScrollView {
                HStack {
                    Text("Welcome, \(user.name)")
                        .font(.footnote)
                        .padding(.horizontal)
                        .foregroundStyle(.black)
                    Spacer()
                }
                ForEach(user.cars, id: \.id) { car in
                    ExpandableSectionView(
                        car: Car(
                            id: car.id,
                            name: car.name,
                            nickname: car.nickname,
                            imageURL: car.imageURL,
                            isSelected: false,
                            carManufacturingYears: [],
                            schedules: car.schedules,
                            currentOdometer: car.currentOdometer
                        ),
                        isExpanded: user.cars.first?.id == car.id
                    ) {
                        SwitchTabRouter.shared.currentTab = .services
                    }
                    .padding(.horizontal)
                }
                Spacer(minLength: 0)
            }
            .padding(.top, 8)

        }
        .background(.svSurfaceHigh)
        .navigationBarBackButtonHidden(true)
    }

    var appHeader: some View {
        VStack(spacing: 0) {
            HStack {
                Image(.icGarageDoor)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(height: 34)
                    .foregroundStyle(.black)

                Text("Ewano")
                    .font(.svHeadlineMobile)
                    .foregroundStyle(.black)

                LottieView(animation: .loginStar)
                    .playing(loopMode: .loop)
                    .frame(width: 32, height: 32)
                    .accessibilityHidden(true)
                Spacer()

                CustomButtonView(config: .init(leadingImage: .icNotifications, leadingImageSize: 30, iconColor: .black, variant: .plain), action: {
                    onTapNotification?()
                })
                .fixedSize()

                Button {
                    onTapProfile?()
                } label: {
                    profileImageView
                }

            }
        }
        .padding(.horizontal, 8)
    }

    var profileImageView: some View {
        VStack {
            if let profileImageURL = user.profileImageURL {
                AppImage(type: .url(profileImageURL))
                    .scaledToFit()
                    .frame(height: 40)
            } else {
                AppImage(type: .local(.icPerson))
                    .scaledToFit()
                    .frame(height: 30)
                    .padding(4)
            }
        }
        .background(.svSecondaryContainer)
        .clipShape(.circle)
    }
}

#Preview {
    HomeView(
        user: .init(
            id: "1",
            name: "Ali",
            email: "ali@gmail.com",
            password: "1234",
            profileImageURL: nil,
            cars: [
                .init(
                    id: "1",
                    name: "Camry",
                    nickname: "Family car",
                    imageURL: "https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=800",
                    isSelected: false,
                    carManufacturingYears: [],
                    schedules: [
                        .init(id: "1-1", title: "Engine Oil & Filter", accumulatedDistance: 500, serviceInterval: 1_000),
                        .init(id: "1-2", title: "Brake Fluid Flush",   accumulatedDistance: 900, serviceInterval: 1_000),
                        .init(id: "1-3", title: "Cabin Air Filter",     accumulatedDistance: 1_000, serviceInterval: 1_000),
                        .init(id: "1-4", title: "Tire Rotation",        accumulatedDistance: 1_150, serviceInterval: 1_000)
                    ],
                    currentOdometer: "4825"
                ),
                .init(
                    id: "2",
                    name: "Corolla",
                    nickname: "Work car",
                    imageURL: "https://images.unsplash.com/photo-1623869675781-80aa31012a5a?w=800",
                    isSelected: false,
                    carManufacturingYears: [],
                    schedules: [
                        .init(id: "2-1", title: "Coolant Change", accumulatedDistance: 300, serviceInterval: 1_000)
                    ],
                    currentOdometer: "12040"
                )
            ]
        )
    )
}
