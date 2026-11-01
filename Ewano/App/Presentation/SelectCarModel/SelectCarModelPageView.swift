//
//  SelectCarModelPageView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import SwiftUI

struct SelectCarModelPageView: View {
    let manufacturer: Manufacturer
    var catalog: CatalogService = Services.shared.catalog

    @Environment(\.navigate) private var navigate
    @State private var state: LoadState<[ManufacturerModel]> = .loading
    @State private var searchText = ""
    @State private var selected: ManufacturerModel?

    private var filteredModels: [ManufacturerModel] {
        let models = state.value ?? []
        let query = searchText.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return models }
        return models.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                stepRow
                    .padding(.top, 8)
                    .padding(.bottom, 8)

                AccentTitleView(title: "Select model")
                    .padding(.bottom, 20)

                SearchBarView(
                    placeholder: "Search \(manufacturer.name) models",
                    text: $searchText,
                    leadingIcon: .icDirectionsCar,
                    buttonForeground: .svOnTertiaryContainer,
                    buttonBackground: .svTertiaryContainer
                )
                .padding(.bottom, 24)

                content

                InfoTipCard(
                    icon: .icVerified,
                    title: "Engine-specific schedules",
                    subtitle: "Service intervals are matched to the engine you choose in the next step.",
                    iconColor: .svTertiary,
                    background: .svSurfaceHigh
                )
                .padding(.top, 20)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(.svSurface)
        .safeAreaInset(edge: .bottom) {
            BottomActionBar {
                CustomButtonView(config: .init(
                    title: selected.map { "Continue with \($0.name)" } ?? "Continue",
                    isEnabled: selected != nil,
                    trailingImage: .icArrowForward,
                    trailingImageSize: 20,
                    titleFont: .svButton,
                    iconColor: .svOnTertiaryContainer,
                    cornerRadius: 28,
                    backgroundColor: .svTertiaryContainer
                )) {
                    guard let selected else { return }
                    navigate(to: .selectEngine(manufacturer: manufacturer, model: selected))
                }
                .shadow(color: .black.opacity(0.12), radius: 4, y: 2)
            }
        }
        .wizardToolbar(step: 2, stepCount: 4)
        .task {
            guard state.value == nil else { return }
            await load()
        }
    }

    private var stepRow: some View {
        HStack {
            HStack(spacing: 6) {
                Circle()
                    .fill(.svTertiaryContainer)
                    .frame(width: 6, height: 6)
                Text("\(manufacturer.name) • Step 02/04".uppercased())
                    .font(.svLabel)
                    .tracking(0.8)
                    .foregroundStyle(.svOnSurfaceVariant)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(.svSurfaceContainer, in: Capsule())

            Spacer(minLength: 8)

            if let models = state.value {
                Text(models.count == 1 ? "1 Model Available" : "\(models.count) Models Available")
                    .font(.svLabel)
                    .foregroundStyle(.svOnSurfaceVariant)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .loading:
            VStack(spacing: 12) {
                ForEach(0..<4, id: \.self) { _ in CarModelRowView(option: nil) }
            }
        case .failed(let message):
            StateMessageView(
                kind: .error,
                icon: .icWarningFill,
                title: "Couldn't load models",
                message: message,
                actionTitle: "Retry",
                action: { Task { await load() } }
            )
        case .loaded(let models) where models.isEmpty:
            StateMessageView(
                kind: .empty,
                icon: .icDirectionsCar,
                title: "No models yet",
                message: "There are no \(manufacturer.name) models in the catalog."
            )
        case .loaded:
            if filteredModels.isEmpty {
                StateMessageView(
                    kind: .empty,
                    icon: .icSearch,
                    title: "No models found",
                    message: "Nothing matches “\(searchText)”."
                )
            } else {
                VStack(spacing: 12) {
                    ForEach(filteredModels, id: \.id) { model in
                        CarModelRowView(
                            option: CarModelOption(
                                id: String(model.id),
                                name: model.name,
                                details: nil,
                                image: model.imageURL.map { .url($0) }
                            ),
                            isSelected: selected?.id == model.id
                        ) {
                            selected = model
                        }
                    }
                }
            }
        }
    }

    private func load() async {
        state = .loading
        do {
            let models = try await catalog.models(manufacturerID: manufacturer.id)
            state = .loaded(models.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending })
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}

#Preview {
    NavigationStack {
        SelectCarModelPageView(manufacturer: Manufacturer(id: 1, name: "Toyota", iconURL: ""))
    }
}
