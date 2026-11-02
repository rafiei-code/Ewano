//
//  TermsPrivacyPageView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/11/01.
//

import SwiftUI

struct TermsPrivacyPageView: View {
    private struct Section: Hashable {
        let title: String
        let points: [String]
    }

    private let terms = [
        Section(title: "Your Account", points: [
            "Provide accurate details when you sign up and keep your password private.",
            "You are responsible for activity that happens under your account."
        ]),
        Section(title: "Maintenance Information", points: [
            "Service intervals, reminders and guides are general estimates based on manufacturer data.",
            "They don't replace your vehicle's owner's manual or the advice of a qualified mechanic."
        ]),
        Section(title: "Fair Use", points: [
            "Don't misuse the app, try to access other people's data, or interfere with the service.",
            "We may update these terms. Continuing to use Ewano means you accept the latest version."
        ])
    ]

    private let privacy = [
        Section(title: "What We Collect", points: [
            "Account details: your full name, username, email address and password.",
            "Vehicle details you add: manufacturer, model, engine, odometer readings and service dates.",
            "An optional profile photo, if you choose to upload one."
        ]),
        Section(title: "How We Use It", points: [
            "Only to run Ewano: building your maintenance schedule, showing reminders and keeping your garage in sync.",
            "We don't sell your personal information or use it for advertising."
        ]),
        Section(title: "How It's Protected", points: [
            "Your data travels over encrypted HTTPS connections and is stored on Ewano's servers.",
            "On your device, your sign-in session is kept in the iOS Keychain and removed when you log out."
        ]),
        Section(title: "Your Choices", points: [
            "You can update your profile from the Profile tab and log out at any time.",
            "To delete your account and its data, contact the Ewano team."
        ])
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Last updated November 1, 2026")
                    .font(.svLabel)
                    .foregroundStyle(.svOnSurfaceVariant)

                group("Terms of Service", sections: terms)
                group("Privacy Policy", sections: privacy)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 40)
        }
        .background(.svSurface)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("TERMS & PRIVACY")
                    .font(.svHeadlineMd)
                    .foregroundStyle(.svOnSurface)
                    .fixedSize()
                    .accessibilityAddTraits(.isHeader)
            }
            .hiddenSharedBackground()
        }
    }

    private func group(_ title: String, sections: [Section]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased())
                .font(.svHeadlineMd)
                .foregroundStyle(.svOnSurface)
                .accessibilityAddTraits(.isHeader)

            VStack(alignment: .leading, spacing: 20) {
                ForEach(sections, id: \.self) { section in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(section.title)
                            .font(.svTitle)
                            .foregroundStyle(.svOnSurface)
                            .accessibilityAddTraits(.isHeader)

                        ForEach(section.points, id: \.self) { point in
                            HStack(alignment: .firstTextBaseline, spacing: 10) {
                                Circle()
                                    .fill(.svTertiary)
                                    .frame(width: 6, height: 6)
                                    .alignmentGuide(.firstTextBaseline) { $0[.bottom] + 4 }
                                    .accessibilityHidden(true)
                                Text(point)
                                    .font(.svBodySm)
                                    .foregroundStyle(.svOnSurfaceVariant)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.svSurfaceLowest, in: RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
        }
    }
}

#Preview {
    NavigationStack {
        TermsPrivacyPageView()
    }
}
