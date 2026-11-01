//
//  WizardToolbar.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import SwiftUI

struct StepProgressIndicator: View {
    let currentStep: Int
    let stepCount: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(1...stepCount, id: \.self) { step in
                Capsule()
                    .fill(step <= currentStep ? Color.svTertiaryContainer : .svSurfaceHighest)
                    .frame(height: 6)
            }
        }
        .frame(width: 168)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Step \(currentStep) of \(stepCount)")
    }
}

extension View {
    func wizardToolbar(step: Int, stepCount: Int) -> some View {
        navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    StepProgressIndicator(currentStep: step, stepCount: stepCount)
                }
                .hiddenSharedBackground()
            }
    }
}

#Preview {
    NavigationStack {
        Color.svSurface
            .wizardToolbar(step: 2, stepCount: 4)
    }
}
