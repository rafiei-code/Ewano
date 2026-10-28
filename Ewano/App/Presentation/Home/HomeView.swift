//
//  HomeView.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/27.
//

import SwiftUI
import Lottie

struct HomeView: View {

    @State var user: UserModel
    var onTapProfile: (() -> Void)?
    @Environment(\.navigate) var navigate

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
                        isExpanded: car.isSelected ?? false
                    ){
                        if let index = user.cars.firstIndex(where: { $0.id == car.id }) {
                            user.cars.moveToFront(at: index)
                        }
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
    HomeView(user: .sample)
}

extension Array {
    /// آیتم در index داده‌شده را به اول آرایه منتقل می‌کند.
    mutating func moveToFront(at index: Int) {
        guard indices.contains(index), index != 0 else { return }
        let item = remove(at: index)
        insert(item, at: 0)
    }

    /// نسخه‌ی غیرتغییردهنده: آرایه‌ی جدید را برمی‌گرداند.
    func movingToFront(at index: Int) -> [Element] {
        var copy = self
        copy.moveToFront(at: index)
        return copy
    }
}
