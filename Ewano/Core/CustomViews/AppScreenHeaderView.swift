//
//  AppScreenHeaderView.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/28.
//

import SwiftUI
import Lottie

struct AppScreenHeaderView: View {

    let user: ProfileResponse
    var hadProfileView: Bool = true
    var onTapProfile: (() -> Void)?
    var onTapNotification: (() -> Void)?

    var body: some View {
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

                if hadProfileView {
                    Button {
                        onTapProfile?()
                    } label: {
                        profileImageView
                    }
                }

            }
        }
        .padding(.horizontal, 8)
    }

    var profileImageView: some View {
        VStack {
            if let profileImageURL = user.imageURL {
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
