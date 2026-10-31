//
//  ProfilePageView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/29.
//

import SwiftUI

struct ProfilePageView: View {

    let userProfile: ProfileResponse
    var onTapEditProfile: (() -> Void)?
    var onTapAbout: (() -> Void)?
    var onTapHelp: (() -> Void)?
    var onTapTerms: (() -> Void)?
    var onTapLogout: (() -> Void)?

    var body: some View {
        VStack(spacing: 0) {
            AppScreenHeaderView(
                user: .init(fullname: userProfile.fullname, email: userProfile.email, imageURL: userProfile.imageURL), hadProfileView: false)

            ScrollView {
                VStack(spacing: 24) {
                    profileCard
                    supportCard
                    logoutCard
                    footer
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
        .background(.svSurfaceHigh)
        .navigationBarBackButtonHidden(true)
    }

    private var profileCard: some View {
        VStack(spacing: 4) {
            ProfileAvatarView(imageURL: userProfile.imageURL)
                .padding(.bottom, 12)

            Text(userProfile.fullname)
                .font(.svHeadlineMobile)
                .foregroundStyle(.svOnSurface)

            Text(userProfile.email ?? "")
                .font(.svLabel)
                .foregroundStyle(.svOnSurfaceVariant)

            Button {
                onTapEditProfile?()
            } label: {
                HStack(spacing: 4) {
                    Text("Edit Profile")
                        .font(.svBodySm)
                    Image(.icArrowForward)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                }
                .foregroundStyle(.svOnTertiaryContainer)
                .padding(.top, 12)
            }
            .buttonStyle(.pressable)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .cardSurface()
    }

    private var supportCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(.icHelpOutline)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(.svOnTertiaryContainer)
                    .accessibilityHidden(true)

                Text("Servio & Support")
                    .font(.svTitle)
                    .foregroundStyle(.svOnSurface)
            }
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isHeader)
            .padding(.bottom, 8)

            SettingsRowView(icon: .icInfo, title: "About Us") { onTapAbout?() }
            SettingsRowView(icon: .icMenuBook, title: "Help Center & Maintenance Guides") { onTapHelp?() }
            SettingsRowView(icon: .icShield, title: "Terms & Privacy Policy") { onTapTerms?() }
        }
        .padding(16)
        .cardSurface()
    }

    private var logoutCard: some View {
        SettingsRowView(icon: .icLogout, title: "Log Out") { onTapLogout?() }
            .padding(16)
            .cardSurface()
    }

    private var footer: some View {
        VStack(spacing: 12) {
            Capsule()
                .fill(.svOutlineVariant)
                .frame(width: 24, height: 3)
                .accessibilityHidden(true)

            Text("Servio iOS v\(appVersion) (Build \(buildNumber)) · Crafted for Drivers")
                .font(.svLabel)
                .foregroundStyle(.svOnSurfaceVariant)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 8)
    }

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}

#Preview {
    ProfilePageView(userProfile: .sample)
}
