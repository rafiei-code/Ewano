//
//  CheckboxView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/27.
//

import SwiftUI

struct CheckboxView: View {
    @Binding var isOn: Bool
    let accessibilityLabel: String

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            RoundedRectangle(cornerRadius: 8)
                .fill(isOn ? .svTertiaryFixed : .svSurfaceLowest)
                .frame(width: 24, height: 24)
                .shadow(color: .black.opacity(0.08), radius: 2, y: 1)
                .overlay {
                    if isOn {
                        Image(.icCheck)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .foregroundStyle(.svTertiary)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .contentShape(Rectangle().inset(by: -10))
        }
        .buttonStyle(.plain)
        .animation(.spring(duration: 0.25), value: isOn)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(isOn ? [.isToggle, .isSelected] : .isToggle)
    }
}

#Preview {
    @Previewable @State var isOn = true
    HStack(spacing: 20) {
        CheckboxView(isOn: $isOn, accessibilityLabel: "Agree")
        CheckboxView(isOn: .constant(false), accessibilityLabel: "Agree")
    }
    .padding()
    .background(.svSurfaceHigh)
}
