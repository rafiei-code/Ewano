//
//  DatePickerField.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/11/01.
//

import SwiftUI

/// A date field that can be empty, which a plain `DatePicker` can't. Tapping it opens a calendar sheet.
struct DatePickerField: View {
    let title: String
    @Binding var date: Date?
    var placeholder: String = "Select date"
    var range: PartialRangeThrough<Date> = ...Date.now

    @State private var isPicking = false
    @State private var pickerDate = Date.now

    var body: some View {
        Button {
            pickerDate = date ?? .now
            isPicking = true
        } label: {
            HStack {
                Text(date?.formatted(date: .abbreviated, time: .omitted) ?? placeholder)
                    .font(.svBody)
                    .fontWeight(.semibold)
                    .foregroundStyle(date == nil ? .svOutline : .svOnSurface)
                Spacer(minLength: 8)
                Image(.icEditCalendar)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.svOnSurfaceVariant)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.svOutlineVariant.opacity(0.6), lineWidth: 2)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.pressable)
        .accessibilityLabel(title)
        .accessibilityValue(date?.formatted(date: .long, time: .omitted) ?? "Not set")
        .sheet(isPresented: $isPicking) {
            VStack(spacing: 16) {
                DatePicker(title, selection: $pickerDate, in: range, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .tint(.svTertiary)

                CustomButtonView(config: .init(
                    title: "Done",
                    titleFont: .svButton,
                    iconColor: .svOnTertiaryContainer,
                    cornerRadius: 12,
                    backgroundColor: .svTertiaryContainer
                )) {
                    date = pickerDate
                    isPicking = false
                }
            }
            .padding(20)
            .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    struct Demo: View {
        @State private var empty: Date?
        @State private var filled: Date? = .now

        var body: some View {
            VStack(spacing: 16) {
                DatePickerField(title: "Last service date", date: $empty)
                DatePickerField(title: "Last service date", date: $filled)
            }
            .padding()
        }
    }
    return Demo()
}
