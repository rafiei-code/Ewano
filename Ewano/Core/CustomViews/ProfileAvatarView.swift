//
//  ProfileAvatarView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/29.
//

import SwiftUI

struct ProfileAvatarView: View {
    var imageURL: String?
    var previewImage: UIImage?
    var diameter: CGFloat = 96
    var hadCamera: Bool = true
    var onTapCamera: () -> Void = {}

    var body: some View {
        avatar
            .frame(width: diameter, height: diameter)
            .clipShape(Circle())
            .overlay(Circle().stroke(.svTertiaryContainer, lineWidth: 3))
            .overlay(alignment: .bottomTrailing) {
                if hadCamera {
                    cameraButton
                }
            }
    }

    @ViewBuilder
    private var avatar: some View {
        if let previewImage {
            Image(uiImage: previewImage)
                .resizable()
                .scaledToFill()
        } else if let imageURL {
            AppImage(type: .url(imageURL), contentMode: .fill)
        } else {
            IconCircleView(
                icon: .icPerson,
                foreground: .svOnSecondaryContainer,
                background: .svSecondaryContainer,
                diameter: diameter,
                iconSize: diameter / 2
            )
        }
    }

    private var cameraButton: some View {
        Button(action: onTapCamera) {
            Image(.icPhotoCamera)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 14, height: 14)
                .foregroundStyle(.svOnTertiaryContainer)
                .frame(width: 28, height: 28)
                .background(.svTertiaryContainer, in: Circle())
        }
        .buttonStyle(.pressable)
        .accessibilityLabel("Change photo")
    }
}

#Preview {
    ProfileAvatarView()
        .padding()
}
