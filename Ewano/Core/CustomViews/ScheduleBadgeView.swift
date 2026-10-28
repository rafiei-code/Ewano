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

    let schedule: ScheduleFilter

    var body: some View {
        BadgeView(
            text: schedule.text,
            image: schedule.icon,
            textFont: .svLabel,
            textColor: schedule.textColor,
            imageColor: schedule.iconColor,
            backgroundColor: schedule.backgroundColor
        )
        .tracking(1.5)
    }
}

#Preview {
    VStack {
        ScheduleBadgeView(schedule: .allGood)
        ScheduleBadgeView(schedule: .overdue)
        ScheduleBadgeView(schedule: .dueSoon)
        ScheduleBadgeView(schedule: .ok)
    }
}
