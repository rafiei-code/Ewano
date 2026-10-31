//
//  HomeView.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/27.
//

import SwiftUI
import Lottie

struct HomeView: View {

    let user: User
    let userCars: [CarModel]

    var onTapProfile: (() -> Void)?
    var onTapNotification: (() -> Void)?
    @Environment(\.navigate) private var navigate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            appHeader
            ScrollView {
                HStack {
                    Text("Welcome, \(user.fullname)")
                        .font(.footnote)
                        .padding(.horizontal)
                        .foregroundStyle(.black)
                    Spacer()
                }

                ForEach(userCars, id: \.id) { car in
                    ExpandableSectionView(
                        car: CarModel(id: car.id, userID: user.id, name: car.name, manufacturerID: car.manufacturerID, manufacturer: car.manufacturer, modelID: car.modelID, model: car.model, engineID: car.engineID, engine: car.engine, imageURL: car.imageURL, imageSourceURL: car.imageSourceURL, maintenance: car.maintenance),
                        isExpanded: /*user.cars.first?.id == car.id*/true
                    ) {
                        SwitchTabRouter.shared.showSchedule(for: car)
                    }
                    .padding(.horizontal)
                }
                Spacer(minLength: 0)
            }
            .padding(.top, 8)

            Color.clear
                .frame(height: 0)

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
            AppImage(type: .local(.icPerson))
                .scaledToFit()
                .frame(height: 30)
                .padding(4)
//            if let profileImageURL = user. { TODO
//                AppImage(type: .url(profileImageURL))
//                    .scaledToFit()
//                    .frame(height: 40)
//            } else {
//            }
        }
        .background(.svSecondaryContainer)
        .clipShape(.circle)
    }
}
