//
//  LabeledFieldRowView.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/26.
//

import SwiftUI

struct LabeledFieldRowView: View {
    let title: String
    let icon: ImageResource
    @Binding var text: String
    var placeholder: String = ""
    var optionalText: String? = "(optional)"
    var trailingIcon: ImageResource?
    var isEditable: Bool = true
    var onTap: (() -> Void)?
    var onTrailingTap: (() -> Void)?

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 16) {
            leadingIcon

            if let onTap {
                Button(action: onTap) { fieldContent }
                    .buttonStyle(.plain)
            } else {
                fieldContent
                    .contentShape(Rectangle())
                    .onTapGesture { isFocused = true }
            }

            if let trailingIcon {
                trailingView(trailingIcon)
            }
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var fieldContent: some View {
        VStack(alignment: .leading, spacing: 2) {
            titleLabel
            valueView
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var titleLabel: some View {
        let base = Text(title.uppercased())
            .font(.svLabel)
            .tracking(1)
            .foregroundColor(.svOnSurfaceVariant)

        return Group {
            if let optionalText {
                 Text("\(base) \(optionalText)")
                    .font(.svLabel)
                    .foregroundColor(.svOutline)
            } else {
                base
            }
        }
    }

    @ViewBuilder
    private var valueView: some View {
        if onTap != nil || !isEditable {
            Text(text.isEmpty ? placeholder : text)
                .font(.svTitle)
                .foregroundStyle(text.isEmpty ? .svOutline : .svOnSurface)
                .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            TextField(placeholder, text: $text)
                .font(.svTitle)
                .foregroundStyle(.svOnSurface)
                .focused($isFocused)
        }
    }

    private var leadingIcon: some View {
        Image(icon)
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: 24, height: 24)
            .foregroundStyle(.svOnSurfaceVariant)
            .frame(width: 56, height: 56)
            .background(Color.svSurfaceContainer, in: Circle())
            .accessibilityHidden(true)
    }

    @ViewBuilder
    private func trailingView(_ resource: ImageResource) -> some View {
        let image = Image(resource)
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: 22, height: 22)
            .foregroundStyle(.svOnSurfaceVariant)

        if let onTrailingTap {
            Button(action: onTrailingTap) {
                image
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        } else {
            image.accessibilityHidden(true)
        }
    }
}

#Preview("Labeled rows") {
    struct Demo: View {
        @State private var date = "Oct 12, 2024"
        @State private var nickname = "Daily Commuter"
        @State private var empty = ""

        var body: some View {
            VStack(spacing: 8) {
                LabeledFieldRowView(
                    title: "Last service date",
                    icon: .icCalendarToday,
                    text: $date,
                    trailingIcon: .icEditCalendar,
                    onTap: {}
                )
                LabeledFieldRowView(
                    title: "Vehicle nickname",
                    icon: .icDirectionsCar,
                    text: $nickname,
                    trailingIcon: .icCheckCircle
                )
                LabeledFieldRowView(
                    title: "Vehicle nickname",
                    icon: .icDirectionsCar,
                    text: $empty,
                    placeholder: "Enter a nickname"
                )
            }
            .padding(16)
            .background(.svBackground)
        }
    }
    return Demo()
}
