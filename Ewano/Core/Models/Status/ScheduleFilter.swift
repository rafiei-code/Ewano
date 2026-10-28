//
//  ScheduleFilter.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 10/28/26.
//

import SwiftUI

public enum ScheduleFilter: CaseIterable, Hashable {
    case allGood
    case overdue
    case dueSoon
    case ok

    init(_ status: ServiceStatus) {
        switch status {
        case .overdue: self = .overdue
        case .dueSoon: self = .dueSoon
        case .ok: self = .ok
        }
    }

    var status: ServiceStatus? {
        switch self {
        case .allGood: nil
        case .overdue: .overdue
        case .dueSoon: .dueSoon
        case .ok: .ok
        }
    }

    var title: String {
        switch self {
        case .allGood: "All good"
        case .overdue: "Overdue"
        case .dueSoon: "Due Soon"
        case .ok: "OK"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .ok:
            return .clear
        case .overdue:
            return .clear
        case .dueSoon:
            return .svTertiaryFixedDim
        case .allGood:
            return .clear
        }
    }

    var text: String {
        switch self {
        case .ok:
            return "OK"
        case .overdue:
            return "Overdue"
        case .dueSoon:
            return "Due Soon"
        case .allGood:
            return "All Good"
        }
    }

    var textColor: Color {
        switch self {
        case .ok:
            return .black
        case .overdue:
            return .svError
        case .dueSoon:
            return .svOnTertiaryContainer
        case .allGood:
            return .svPrimary
        }
    }

    var iconColor: Color {
        switch self {
        case .overdue:
            return .svError
        case .allGood:
            return .svPrimary
        default:
            return .clear
        }
    }

    var icon: ImageResource? {
        switch self {
        case .overdue:
            return .icWarning
        case .allGood:
            return .icDoneAll
        default:
            return nil
        }
    }
}
