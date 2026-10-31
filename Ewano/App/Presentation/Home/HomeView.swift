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
    let userProfile: ProfileResponse
    let userCars: [CarModel]

    var onTapProfile: (() -> Void)?
    var onTapNotification: (() -> Void)?
    @Environment(\.navigate) private var navigate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AppScreenHeaderView(user: userProfile, onTapNotification:  {
            })
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
                        isExpanded: userCars.first?.id == car.id,
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

    var profileImageView: some View {
        VStack {
            if let profileImageURL = userProfile.imageURL { 
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
