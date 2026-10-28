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
        .animation(.spring(response: 0.25, dampingFraction: 1), value: isOn)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(accessibilityTraits)
    }

    private var accessibilityTraits: AccessibilityTraits {
        var traits: AccessibilityTraits = isOn ? .isSelected : []
        if #available(iOS 17.0, *) {
            traits.insert(.isToggle)
        }
        return traits
    }
}

//#Preview {
//    @Previewable @State var isOn = true
//    HStack(spacing: 20) {
//        CheckboxView(isOn: $isOn, accessibilityLabel: "Agree")
//        CheckboxView(isOn: .constant(false), accessibilityLabel: "Agree")
//    }
//    .padding()
//    .background(.svSurfaceHigh)
//}
