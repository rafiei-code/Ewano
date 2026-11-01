//
//  GuideCardView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/11/01.
//

import SwiftUI

struct GuideCardView: View {
    let guide: MaintenanceGuide
    let isExpanded: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onToggle) { header }
                .buttonStyle(.plain)
                .accessibilityHint(isExpanded ? "Collapses the guide" : "Expands the guide")

            if isExpanded {
                Divider()
                    .overlay(Color.svSurfaceContainer)
                details
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(.svSurfaceLowest, in: RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.svOutlineVariant.opacity(0.3), lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(guide.icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 26, height: 26)
                .foregroundStyle(iconForeground)
                .frame(width: 48, height: 48)
                .background(iconBackground, in: RoundedRectangle(cornerRadius: 12))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text("\(guide.readMinutes) min read")
                        .foregroundStyle(.svSecondary)
                    Text("•")
                        .foregroundStyle(.svSecondary)
                        .accessibilityHidden(true)
                    Text(guide.level.title)
                        .bold()
                        .foregroundStyle(levelColor)
                }
                .font(.svLabel)
                .padding(.bottom, 2)

                Text(guide.title)
                    .font(.svTitle)
                    .foregroundStyle(.svOnSurface)
                    .lineLimit(isExpanded ? nil : 1)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: isExpanded)

                Text(guide.summary)
                    .font(.svBodySm)
                    .foregroundStyle(.svOnSurfaceVariant)
                    .lineLimit(isExpanded ? nil : 1)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: isExpanded)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(.icExpandMore)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(.svOnSurfaceVariant)
                .rotationEffect(.degrees(isExpanded ? 180 : 0))
                .frame(width: 36, height: 36)
                .background(.svSurfaceContainer, in: Circle())
                .padding(.top, 4)
                .accessibilityHidden(true)
        }
        .padding(16)
        .contentShape(Rectangle())
    }

    private var details: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(guide.intro)
                .font(.svBodySm)
                .foregroundStyle(.svOnSurface)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)

            VStack(alignment: .leading, spacing: 10) {
                Text("ACTIONABLE STEPS")
                    .font(.svLabel)
                    .bold()
                    .tracking(0.8)
                    .foregroundStyle(.svSecondary)

                ForEach(Array(guide.steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1)")
                            .font(.svGaugeCaption)
                            .foregroundStyle(.svOnPrimary)
                            .frame(width: 20, height: 20)
                            .background(.svPrimary, in: Circle())
                            .padding(.top, 1)
                            .accessibilityHidden(true)

                        (Text("\(step.title): ").fontWeight(.semibold) + Text(step.detail))
                            .font(.svBodySm)
                            .foregroundStyle(.svOnSurface)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Step \(index + 1). \(step.title): \(step.detail)")
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.svSurfaceLow, in: RoundedRectangle(cornerRadius: 8))

            noteBox

            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Image(.icHandyman)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(.svSecondary)
                    .alignmentGuide(.firstTextBaseline) { $0[.bottom] - 4 }
                    .accessibilityHidden(true)
                (Text("Required Tools: ").bold().foregroundColor(.svSecondary) + Text(guide.tools))
                    .font(.svLabel)
                    .foregroundStyle(.svOnSurfaceVariant)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.svSurfaceContainer, in: RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 16)
    }

    private var noteBox: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(guide.note.kind == .tip ? .icLightbulb : .icWarning)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(.svTertiary)
                .accessibilityHidden(true)
            (Text("\(guide.note.title): ").bold() + Text(guide.note.text))
                .font(.svLabel)
                .foregroundStyle(.svOnTertiaryContainer)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.svTertiaryFixed.opacity(0.3), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color.svTertiary.opacity(0.2), lineWidth: 1)
        }
    }

    private var iconBackground: Color {
        switch guide.iconStyle {
        case .gold: .svTertiaryFixed.opacity(0.6)
        case .neutral: .svSurfaceHigh
        case .lavender: .svSecondaryContainer
        }
    }

    private var iconForeground: Color {
        switch guide.iconStyle {
        case .gold: .svOnTertiaryFixed
        case .neutral: .svOnSurface
        case .lavender: .svOnSecondaryContainer
        }
    }

    private var levelColor: Color {
        switch guide.level {
        case .beginner: .svTertiary
        case .intermediate: .svSecondary
        case .quickFix: .svPrimary
        }
    }
}

#Preview {
    struct Demo: View {
        @State private var expanded: Set<String> = ["engine-oil"]

        var body: some View {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(MaintenanceGuide.all) { guide in
                        GuideCardView(guide: guide, isExpanded: expanded.contains(guide.id)) {
                            if expanded.contains(guide.id) { expanded.remove(guide.id) } else { expanded.insert(guide.id) }
                        }
                    }
                }
                .padding()
            }
            .background(.svSurface)
        }
    }
    return Demo()
}
