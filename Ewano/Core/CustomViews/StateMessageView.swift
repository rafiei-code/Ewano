//
//  StateMessageView.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI

struct StateMessageView: View {

    enum Kind {
        case empty
        case error
    }

    let kind: Kind
    let icon: ImageResource
    let title: String
    var message: String?
    var actionTitle: String?
    var action: (() -> Void)?

    private var iconBackground: Color {
        kind == .error ? .svErrorContainer : .svSurfaceContainer
    }

    private var iconForeground: Color {
        kind == .error ? .svOnErrorContainer : .svOnSurfaceVariant
    }

    var body: some View {
        VStack(spacing: 16) {
            Image(icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 36, height: 36)
                .foregroundStyle(iconForeground)
                .frame(width: 88, height: 88)
                .background(iconBackground, in: Circle())
                .accessibilityHidden(true)

            VStack(spacing: 6) {
                Text(title)
                    .font(.svHeadlineMobile)
                    .foregroundStyle(.svOnSurface)
                    .multilineTextAlignment(.center)

                if let message {
                    Text(message)
                        .font(.svBody)
                        .foregroundStyle(.svOnSurfaceVariant)
                        .multilineTextAlignment(.center)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .accessibilityElement(children: .combine)

            if let actionTitle, let action {
                CustomButtonView(
                    config: .init(
                        title: actionTitle,
                        style: .enabled,
                        titleFont: .svButton,
                        size: .normal
                    ),
                    action: action
                )
                .padding(.top, 8)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
    }
}

#Preview("Empty") {
    StateMessageView(
        kind: .empty,
        icon: .icGarage,
        title: "No vehicles yet",
        message: "Add your first vehicle to start tracking services.",
        actionTitle: "Add vehicle",
        action: {}
    )
    .background(.svBackground)
}

#Preview("Error") {
    StateMessageView(
        kind: .error,
        icon: .icWarningFill,
        title: "Something went wrong",
        message: "We couldn't load your data. Please try again.",
        actionTitle: "Retry",
        action: {}
    )
    .background(.svBackground)
}

#Preview("Large text") {
    StateMessageView(
        kind: .empty,
        icon: .icGarage,
        title: "No vehicles yet",
        message: "Add your first vehicle to start tracking services."
    )
    .environment(\.dynamicTypeSize, .accessibility2)
}
