//
//  SearchBarView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import SwiftUI

struct SearchBarView: View {
    let placeholder: String
    @Binding var text: String
    var leadingIcon: ImageResource?
    var buttonForeground: Color = .svInverseOnSurface
    var buttonBackground: Color = .svInverseSurface

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 12) {
            if let leadingIcon {
                Image(leadingIcon)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.svOutline)
                    .accessibilityHidden(true)
            }

            TextField(placeholder, text: $text)
                .font(.svBody)
                .foregroundStyle(.svOnSurface)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .submitLabel(.search)
                .focused($isFocused)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(.icClose)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.svOutline)
                        .frame(width: 32, height: 32)
                        .contentShape(Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear search")
            }

            Button {
                isFocused.toggle()
            } label: {
                Image(.icSearch)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(buttonForeground)
                    .frame(width: 40, height: 40)
                    .background(buttonBackground, in: Circle())
            }
            .buttonStyle(.pressable)
            .accessibilityLabel("Search")
        }
        .padding(.leading, leadingIcon == nil ? 20 : 16)
        .padding(.trailing, 8)
        .frame(height: 56)
        .background(.svSurfaceLowest, in: Capsule())
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
}

#Preview {
    struct Demo: View {
        @State private var brand = ""
        @State private var model = "Cam"

        var body: some View {
            VStack(spacing: 16) {
                SearchBarView(placeholder: "Search brand", text: $brand)
                SearchBarView(
                    placeholder: "Search Toyota models",
                    text: $model,
                    leadingIcon: .icDirectionsCar,
                    buttonForeground: .svOnTertiaryContainer,
                    buttonBackground: .svTertiaryContainer
                )
            }
            .padding()
            .background(.svSurface)
        }
    }
    return Demo()
}
