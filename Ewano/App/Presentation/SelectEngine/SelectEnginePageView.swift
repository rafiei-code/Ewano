//
//  SelectEnginePageView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import SwiftUI

struct SelectEnginePageView: View {
    let manufacturer: Manufacturer
    let model: ManufacturerModel
    var catalog: CatalogService = Services.shared.catalog
    var userCars: UserCarsService = Services.shared.userCars

    @Environment(\.navigate) private var navigate
    @State private var state: LoadState<[ModelEngine]> = .loading
    @State private var engine: ModelEngine?
    @State private var transmission = NewCarSelection.Transmission.automatic
    @State private var isCreating = false
    @State private var createError: String?
    @State private var createdCar: CarModel?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                vehiclePreview

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("ENGINE CONFIGURATION")
                            .font(.svHeadlineMd)
                            .foregroundStyle(.svOnSurface)
                        Spacer(minLength: 8)
                        Text("REQUIRED")
                            .font(.svLabel)
                            .foregroundStyle(.svOnSurfaceVariant)
                    }
                    engines
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("TRANSMISSION")
                        .font(.svHeadlineMd)
                        .foregroundStyle(.svOnSurface)
                    SegmentedChoiceView(
                        options: NewCarSelection.Transmission.allCases,
                        selection: $transmission
                    ) { $0.rawValue }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
            .disabled(isCreating)
        }
        .background(.svSurface)
        .safeAreaInset(edge: .bottom) {
            BottomActionBar {
                VStack(spacing: 10) {
                    if let createError {
                        Text(createError)
                            .font(.svBodySm)
                            .foregroundStyle(.svError)
                            .multilineTextAlignment(.center)
                    }

                    CustomButtonView(config: .init(
                        title: "CONTINUE",
                        isEnabled: engine != nil,
                        isLoading: isCreating,
                        trailingImage: .icArrowForward,
                        trailingImageSize: 20,
                        titleFont: .svButton,
                        titleTracking: 0.85,
                        iconColor: .svOnTertiaryContainer,
                        cornerRadius: 12,
                        backgroundColor: .svTertiaryContainer
                    ), action: createCar)
                    .shadow(color: .black.opacity(0.12), radius: 4, y: 2)
                }
            }
        }
        .wizardToolbar(step: 3, stepCount: 4)
        .navigationBarBackButtonHidden(isCreating)
        .onChange(of: engine) { _ in createError = nil }
        .task {
            guard state.value == nil else { return }
            await load()
        }
    }

    private var vehiclePreview: some View {
        VStack(spacing: 12) {
            ZStack {
                Ellipse()
                    .fill(.svTertiaryFixed.opacity(0.3))
                    .frame(width: 288, height: 128)
                    .blur(radius: 24)

                if let imageURL = model.imageURL {
                    AppImage(type: .url(imageURL), contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .frame(maxHeight: 190)
                } else {
                    Image(.icDirectionsCar)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 96, height: 96)
                        .foregroundStyle(.svOutlineVariant)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 190)
            .accessibilityHidden(true)

            HStack(spacing: 8) {
                Circle()
                    .fill(.svTertiary)
                    .frame(width: 8, height: 8)
                Text("\(manufacturer.name) \(model.name)".uppercased())
                    .font(.svLabel)
                    .bold()
                    .tracking(0.8)
                    .foregroundStyle(.svOnSurfaceVariant)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(.svSurfaceContainer, in: Capsule())
            .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
        }
        .padding(.top, 8)
    }

    @ViewBuilder
    private var engines: some View {
        switch state {
        case .loading:
            VStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { _ in engineSkeleton }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Loading engines")
        case .failed(let message):
            StateMessageView(
                kind: .error,
                icon: .icWarningFill,
                title: "Couldn't load engines",
                message: message,
                actionTitle: "Retry",
                action: { Task { await load() } }
            )
        case .loaded(let engines) where engines.isEmpty:
            StateMessageView(
                kind: .empty,
                icon: .icSettingsSuggest,
                title: "No engines yet",
                message: "There are no engines listed for the \(model.name)."
            )
        case .loaded(let engines):
            VStack(spacing: 8) {
                ForEach(engines, id: \.id) { item in
                    SelectableEngineConfigurationView(
                        title: item.name,
                        description: item.fuelDescription,
                        icon: item.fuelIcon,
                        isSelected: engine?.id == item.id
                    ) {
                        engine = item
                    }
                }
            }
        }
    }

    private var engineSkeleton: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 8)
                .fill(.svSurfaceHigh)
                .frame(width: 40, height: 40)
            VStack(alignment: .leading, spacing: 8) {
                Capsule().fill(.svSurfaceHigh).frame(width: 140, height: 14)
                Capsule().fill(.svSurfaceHigh).frame(width: 80, height: 10)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .background(.svSurfaceLowest, in: RoundedRectangle(cornerRadius: 12))
        .shimmer()
    }

    private func createCar() {
        guard let engine, !isCreating else { return }
        let selection = NewCarSelection(manufacturer: manufacturer, model: model, engine: engine, transmission: transmission)

        // Coming back to this step and continuing with the same engine reuses the car instead of adding a duplicate.
        if let createdCar, createdCar.engineID == engine.id {
            navigate(to: .maintenanceSetup(selection, car: createdCar))
            return
        }

        isCreating = true
        createError = nil
        Task {
            do {
                let car = try await userCars.createCar(CreateUserCarRequest(
                    manufacturerID: manufacturer.id,
                    modelID: model.id,
                    engineID: engine.id,
                    name: selection.title
                ))
                createdCar = car
                navigate(to: .maintenanceSetup(selection, car: car))
            } catch {
                createError = error.localizedDescription
            }
            isCreating = false
        }
    }

    private func load() async {
        state = .loading
        do {
            let engines = try await catalog.engines(modelID: model.id)
            state = .loaded(engines)
            if engines.count == 1 {
                engine = engines.first
            }
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}

#Preview {
    NavigationStack {
        SelectEnginePageView(
            manufacturer: Manufacturer(id: 1, name: "Toyota", iconURL: ""),
            model: ManufacturerModel(id: 1, manufacturerID: 1, name: "Camry", imageURL: nil, imageSourceURL: nil, sourceURL: nil, notes: nil)
        )
    }
}
