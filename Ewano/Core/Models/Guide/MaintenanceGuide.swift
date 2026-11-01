//
//  MaintenanceGuide.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/11/01.
//

import SwiftUI

struct MaintenanceGuide: Identifiable, Hashable {
    enum Level {
        case beginner
        case intermediate
        case quickFix

        var title: String {
            switch self {
            case .beginner: "Beginner"
            case .intermediate: "Intermediate"
            case .quickFix: "Quick Fix"
            }
        }
    }

    enum IconStyle {
        case gold
        case neutral
        case lavender
    }

    struct Step: Hashable {
        let title: String
        let detail: String
    }

    struct Note: Hashable {
        enum Kind {
            case tip
            case warning
        }

        let kind: Kind
        let title: String
        let text: String
    }

    let id: String
    let icon: ImageResource
    let iconStyle: IconStyle
    let readMinutes: Int
    let level: Level
    let title: String
    let summary: String
    let intro: String
    let steps: [Step]
    let note: Note
    let tools: String
}

extension MaintenanceGuide {
    static let all: [MaintenanceGuide] = [
        MaintenanceGuide(
            id: "engine-oil",
            icon: .icOilBarrel,
            iconStyle: .gold,
            readMinutes: 3,
            level: .beginner,
            title: "How to check engine oil & fluid levels",
            summary: "Accurate dipstick readings, oil color evaluation & safe topping up",
            intro: "Regular oil level inspections prevent premature engine wear and catastrophic oil starvation. Check the oil level on flat ground with the engine warmed up and shut off for at least 5 minutes to allow drain-down.",
            steps: [
                Step(title: "Park & Cool", detail: "Park on level ground. Turn off the engine and wait 5–10 minutes for oil to settle into the sump."),
                Step(title: "Locate & Pull", detail: "Pull out the brightly colored dipstick loop. Wipe it completely clean with a lint-free shop rag."),
                Step(title: "Re-insert & Read", detail: "Push the dipstick all the way in until seated, then pull back out. Ensure oil film rests between MIN and MAX notches."),
                Step(title: "Inspect & Top Up", detail: "If oil sits below halfway, remove oil filler cap and add 0.5 qt increments of manufacturer-certified viscosity.")
            ],
            note: Note(kind: .tip, title: "Pro-Tip", text: "Milky or frothy light brown oil suggests coolant leakage (blown head gasket). Jet black oil with grit needs an immediate oil & filter flush."),
            tools: "Microfiber rag, clean funnel, OEM viscosity oil"
        ),
        MaintenanceGuide(
            id: "brake-pads",
            icon: .icDiscFull,
            iconStyle: .neutral,
            readMinutes: 5,
            level: .intermediate,
            title: "Brake pad inspection & wear signs",
            summary: "Spotting squeal indicators & rotor friction margins",
            intro: "Brake pad friction material naturally wears away with every stop. Visual checks through wheel spokes or during tire rotations ensure stopping power is never compromised.",
            steps: [
                Step(title: "Visual Angle", detail: "Look through alloy spokes or remove wheel with jack stands for clear line-of-sight to the caliper."),
                Step(title: "Measure Pad Depth", detail: "Locate friction lining pressed against the steel rotor. Pad thickness should measure at least 3mm–4mm (1/8\")."),
                Step(title: "Check Rotor Grooving", detail: "Run a fingernail lightly over cold rotor faces. Deep concentric channels indicate metal-on-metal scoring."),
                Step(title: "Assess Wear Symmetry", detail: "Compare inner and outer pads. Asymmetrical wear signals sticking guide pins or seized caliper pistons.")
            ],
            note: Note(kind: .warning, title: "Safety Warning", text: "Never drive if pad lining is under 2mm. Metallic acoustic squealers will scrape the rotor, rapidly escalating repair costs."),
            tools: "Flashlight, brake pad gauge or ruler, floor jack & stands"
        ),
        MaintenanceGuide(
            id: "obd-codes",
            icon: .icMinorCrash,
            iconStyle: .lavender,
            readMinutes: 4,
            level: .beginner,
            title: "Understanding OBD-II fault codes",
            summary: "Demystifying check engine DTCs, freeze frames & sensor faults",
            intro: "The On-Board Diagnostics port (OBD-II) translates engine warning lights into standardized 5-character trouble codes (e.g. P0300, P0420, P0171) storing exact live freeze frame data.",
            steps: [
                Step(title: "Plug Scanner", detail: "Locate the 16-pin trapezoidal DLC connector beneath the driver dashboard knee bolster."),
                Step(title: "Key ON Engine OFF", detail: "Turn ignition to accessory power (position II) so the onboard ECU module communicates."),
                Step(title: "Read & Log Codes", detail: "Distinguish between Active (triggered light), Pending (intermittent fault), and Permanent DTCs."),
                Step(title: "Export Freeze Frame", detail: "Document RPM, fuel trim, and coolant temperature recorded at the split second the code tripped.")
            ],
            note: Note(kind: .tip, title: "Pro-Tip", text: "Do not immediately clear codes without repairing the underlying fault. Clearing resets emissions readiness monitors, failing inspection."),
            tools: "Handheld OBD-II Scanner or Bluetooth/Wi-Fi Dongle"
        ),
        MaintenanceGuide(
            id: "maintenance-light",
            icon: .icBuildCircle,
            iconStyle: .gold,
            readMinutes: 2,
            level: .quickFix,
            title: "Resetting the maintenance required light",
            summary: "Odometer trip stem & cluster menu sequences",
            intro: "After performing an oil service or scheduled checkup, reset the mileage countdown reminder so interval alerts accurately prompt your next maintenance cycle.",
            steps: [
                Step(title: "Cycle to Trip A", detail: "Switch ignition ON and toggle gauge cluster display until 'Trip A' or 'Total Mileage' appears."),
                Step(title: "Turn Ignition Off", detail: "Turn the ignition switch completely to OFF or LOCK position."),
                Step(title: "Hold Stem & Power On", detail: "Depress and hold the Trip odometer button; simultaneously turn ignition to ON without cranking engine."),
                Step(title: "Watch Countdown", detail: "Keep button held as flashes or zeros count down across screen until 'COMPLETE' or 100% displays.")
            ],
            note: Note(kind: .tip, title: "Pro-Tip", text: "On modern digital cockpits (e.g. Ford, BMW, Honda), this is found under Settings > Vehicle > Oil Life Maintenance via steering buttons."),
            tools: "Vehicle ignition key / push-to-start button, owner's manual"
        ),
        MaintenanceGuide(
            id: "battery",
            icon: .icBatteryChargingFull,
            iconStyle: .neutral,
            readMinutes: 4,
            level: .beginner,
            title: "Battery health check & terminal cleaning",
            summary: "Corrosion neutralization & resting voltage verification",
            intro: "Lead-acid 12V batteries suffer from acidic vapor build-up that forms resistive crust on post terminals, causing weak starts, slow cranking, and premature alternator strain.",
            steps: [
                Step(title: "Disconnect Negative First", detail: "Loosen 10mm bolt and remove the black negative (-) clamp first to avoid accidental chassis grounding sparks."),
                Step(title: "Neutralize Crust", detail: "Mix baking soda and warm water. Scrub blue-white crystalline sulfate crust using a wire battery terminal brush."),
                Step(title: "Rinse & Protect", detail: "Wipe thoroughly dry. Apply dielectric grease or petroleum jelly to posts before reconnecting positive (+), then negative (-)."),
                Step(title: "Check Voltage", detail: "Probe terminals with multimeter. Healthy resting voltage is 12.6V+ (100% charge); below 12.2V indicates dying cells.")
            ],
            note: Note(kind: .warning, title: "Pro-Tip & Safety", text: "Wear protective glasses and nitrile gloves. Battery acid fumes emit flammable hydrogen gas during charging and cranking."),
            tools: "10mm wrench, wire brush, baking soda solution, digital multimeter"
        )
    ]
}
