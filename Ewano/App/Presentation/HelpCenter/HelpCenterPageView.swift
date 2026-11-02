//
//  HelpCenterPageView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/11/01.
//

import SwiftUI

struct HelpCenterPageView: View {
    var guides: [MaintenanceGuide] = MaintenanceGuide.all

    @State private var expandedGuides: Set<String> = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .firstTextBaseline) {
                    Text("COMMON MAINTENANCE GUIDES")
                        .font(.svHeadlineMd)
                        .foregroundStyle(.svOnSurface)
                        .accessibilityAddTraits(.isHeader)
                    Spacer(minLength: 8)
                    Text(guides.count == 1 ? "1 Guide" : "\(guides.count) Guides")
                        .font(.svLabel)
                        .foregroundStyle(.svOnSurfaceVariant)
                }

                ForEach(guides) { guide in
                    GuideCardView(guide: guide, isExpanded: expandedGuides.contains(guide.id)) {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            toggle(guide)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 40)
        }
        .background(.svSurface)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("HELP & GUIDES")
                    .font(.svHeadlineMd)
                    .foregroundStyle(.svOnSurface)
                    .fixedSize()
                    .accessibilityAddTraits(.isHeader)
            }
            .hiddenSharedBackground()
        }
    }

    private func toggle(_ guide: MaintenanceGuide) {
        if expandedGuides.contains(guide.id) {
            expandedGuides.remove(guide.id)
        } else {
            expandedGuides.insert(guide.id)
        }
    }
}

#Preview {
    NavigationStack {
        HelpCenterPageView()
    }
}
