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
    @Environment(\.navigate) private var navigate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AppScreenHeaderView(user: userProfile, onTapProfile: {
                SwitchTabRouter.shared.currentTab = .more
            })
            ScrollView {
                HStack {
                    Text("Welcome, \(user.fullname)")
                        .font(.footnote)
                        .padding(.horizontal)
                        .foregroundStyle(.black)
                    Spacer()
                }

                Group {
                    if userCars.isEmpty {
                        StateMessageView(
                            kind: .empty,
                            icon: .icDirectionsCar,
                            title: "No vehicle",
                            message: "Add a vehicle from garage"
                        )
                        .padding(.top, 40)
                    } else {
                        ForEach(userCars, id: \.id) { car in

                            ExpandableSectionView(
                                car: car,
                                isExpanded: userCars.first?.id == car.id,
                            ) {
                                SwitchTabRouter.shared.showSchedule(for: car)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 24)
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
