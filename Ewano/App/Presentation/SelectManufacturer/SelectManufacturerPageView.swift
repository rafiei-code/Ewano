//
//  SelectManufacturerPageView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import SwiftUI

struct SelectManufacturerPageView: View {
    var catalog: CatalogService = Services.shared.catalog

    @Environment(\.navigate) private var navigate
    @State private var state: LoadState<[Manufacturer]> = .loading
    @State private var searchText = ""
    @State private var selected: Manufacturer?

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)

    private var filteredManufacturers: [Manufacturer] {
        let manufacturers = state.value ?? []
        let query = searchText.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return manufacturers }
        return manufacturers.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                AccentTitleView(title: "Choose your brand")
                    .padding(.top, 8)
                    .padding(.bottom, 16)

                SearchBarView(placeholder: "Search brand", text: $searchText)
                    .padding(.bottom, 20)

                HStack {
                    Text("MANUFACTURERS")
                        .font(.svLabel)
                        .tracking(0.8)
                        .foregroundStyle(.svOnSurfaceVariant)
                    Spacer(minLength: 8)
                    Text("Step 1 of 4")
                        .font(.svBodySm)
                        .foregroundStyle(.svSecondary)
                }
                .padding(.horizontal, 4)
                .padding(.bottom, 12)

                content

                if let selected {
                    selectionBanner(selected)
                        .padding(.top, 20)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
            .animation(.easeOut(duration: 0.2), value: selected)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(.svSurface)
        .safeAreaInset(edge: .bottom) {
            BottomActionBar {
                CustomButtonView(config: .init(
                    title: "CONTINUE",
                    isEnabled: selected != nil,
                    trailingImage: .icArrowForward,
                    trailingImageSize: 20,
                    titleFont: .svButton,
                    titleTracking: 0.85,
                    iconColor: .svOnTertiaryContainer,
                    cornerRadius: 16,
                    backgroundColor: .svTertiaryContainer
                )) {
                    guard let selected else { return }
                    navigate(to: .selectCarModel(manufacturer: selected))
                }
                .shadow(color: .black.opacity(0.12), radius: 4, y: 2)
            }
        }
        .wizardToolbar(step: 1, stepCount: 4)
        .task {
            guard state.value == nil else { return }
            await load()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .loading:
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(0..<12, id: \.self) { _ in brandSkeleton }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Loading manufacturers")
        case .failed(let message):
            StateMessageView(
                kind: .error,
                icon: .icWarningFill,
                title: "Couldn't load brands",
                message: message,
                actionTitle: "Retry",
                action: { Task { await load() } }
            )
        case .loaded:
            if filteredManufacturers.isEmpty {
                StateMessageView(
                    kind: .empty,
                    icon: .icSearch,
                    title: "No brands found",
                    message: "Nothing matches “\(searchText)”."
                )
            } else {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(filteredManufacturers, id: \.id) { manufacturer in
                        SelectableCarBrandView(
                            logo: .url(manufacturer.iconURL),
                            name: manufacturer.name,
                            isSelected: selected?.id == manufacturer.id
                        ) {
                            selected = manufacturer
                        }
                    }
                }
            }
        }
    }

    private var brandSkeleton: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(.svSurfaceHigh)
                .frame(width: 44, height: 44)
            Capsule()
                .fill(.svSurfaceHigh)
                .frame(width: 60, height: 14)
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(.svSurfaceLowest, in: RoundedRectangle(cornerRadius: 16))
        .shimmer()
    }

    private func selectionBanner(_ manufacturer: Manufacturer) -> some View {
        HStack(spacing: 12) {
            Text(manufacturer.name.prefix(1).uppercased())
                .font(.svHeadlineMd)
                .foregroundStyle(.svOnTertiaryFixed)
                .frame(width: 48, height: 48)
                .background(.svTertiaryFixed, in: RoundedRectangle(cornerRadius: 12))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text("Currently Selected")
                    .font(.svBodySm)
                    .foregroundStyle(.svOnSurfaceVariant)
                Text(manufacturer.name)
                    .font(.svTitle)
                    .foregroundStyle(.svOnSurface)
            }

            Spacer(minLength: 8)

            Image(.icVerified)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(.svTertiary)
                .accessibilityHidden(true)
        }
        .padding(12)
        .background(.svSurfaceLow, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
        .accessibilityElement(children: .combine)
    }

    private func load() async {
        state = .loading
        do {
            let manufacturers = try await catalog.manufacturers()
            state = .loaded(manufacturers.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending })
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}

#Preview {
    NavigationStack {
        SelectManufacturerPageView()
    }
}
