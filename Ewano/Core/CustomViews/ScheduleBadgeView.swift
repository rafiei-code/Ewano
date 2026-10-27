//
//  ScheduleBadgeView.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/27.
//

import SwiftUI

struct ScheduleBadgeView: View {

    enum ScheduleType {
        case ok
        case overdue
        case deuSoon
        case allGood
    }

    let schedule: ScheduleType

    var body: some View {
        BadgeView(
            text: badgeText,
            image: badgeIcon,
            textFont: .svLabel,
            textColor: badgeTextColor,
            imageColor: badgeIconColor,
            backgroundColor: badgeBackgroundColor
        )
        .tracking(1.5)
    }

    var badgeBackgroundColor: Color {
        switch schedule {
        case .ok:
            return .clear
        case .overdue:
            return .clear
        case .deuSoon:
            return .svTertiaryFixedDim
        case .allGood:
            return .clear
        }
    }

    var badgeText: String {
        switch schedule {
        case .ok:
            return "OK"
        case .overdue:
            return "Overdue"
        case .deuSoon:
            return "Due Soon"
        case .allGood:
            return "All Good"
        }
    }

    var badgeTextColor: Color {
        switch schedule {
        case .ok:
            return .black
        case .overdue:
            return .svError
        case .deuSoon:
            return .svOnTertiaryContainer
        case .allGood:
            return .svPrimary
        }
    }

    var badgeIconColor: Color {
        switch schedule {
        case .overdue:
            return .svError
        case .allGood:
            return .svPrimary
        default:
            return .clear
        }
    }

    var badgeIcon: ImageResource? {
        switch schedule {
        case .overdue:
            return .icWarning
        case .allGood:
            return .icDoneAll
        default:
            return nil
        }
    }
}

#Preview {
    VStack {
        ScheduleBadgeView(schedule: .allGood)
        ScheduleBadgeView(schedule: .overdue)
        ScheduleBadgeView(schedule: .deuSoon)
        ScheduleBadgeView(schedule: .ok)
    }
}
