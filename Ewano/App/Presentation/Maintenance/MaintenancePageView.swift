//
//  MaintenancePageView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import SwiftUI

/// The last add-car step, and the editor the Schedule tab opens for an existing car (no `selection`).
struct MaintenancePageView: View {
    var selection: NewCarSelection?
    let car: CarModel
    var userCars: UserCarsService = Services.shared.userCars

    @Environment(\.navigate) private var navigate
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userData: UserDataStore
    @State private var nickname = ""
    @State private var odometer = ""
    @State private var unit: DistanceUnit = UserDefaults.standard.bool(forKey: AppPreferences.prefersMilesKey) ? .miles : .kilometers
    @State private var lastServiceDate: Date?
    @State private var lastServiceKMs: [Int: String] = [:]
    @State private var originalKMs: [Int: String] = [:]
    @State private var originalDate: Date?
    @State private var isSaving = false
    @State private var saveError: String?
    @State private var hasPrefilled = false
    @FocusState private var isOdometerFocused: Bool

    private var isEditing: Bool {
        selection == nil
    }

    private var odometerValue: Int? {
        Int(odometer)
    }

    private var requiredItems: [MaintenanceModel] {
        car.maintenance.filter(\.isRequired)
    }

    private var conditionalItems: [MaintenanceModel] {
        car.maintenance.filter(\.isConditional)
    }

    private var services: [MaintenanceModel] {
        requiredItems + conditionalItems
    }

    private var canSave: Bool {
        guard let odometerValue, odometerValue > 0,
              lastServiceDate != nil else {
            return false
        }

        return requiredItems.allSatisfy { item in
            guard item.hasInterval else { return true }

            guard let value = Int(lastServiceKMs[item.maintenanceTypeID] ?? ""),
                  value > 0,
                  value <= odometerValue else {
                return false
            }

            return true
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    AccentTitleView(title: isEditing ? "Update maintenance schedule" : "Setup maintenance schedule")
                    Text(isEditing ? "Update your latest mileage & service date." : "Enter your current mileage and when each service was last done.")
                        .font(.svBodySm)
                        .foregroundStyle(.svOnSurfaceVariant)
                }
                .padding(.top, 8)
                .padding(.bottom, 24)

                vehicleCard
                    .padding(.bottom, 20)

                baselineSection
                    .padding(.bottom, 24)

                servicesSections

                InfoTipCard(
                    icon: .icInfo,
                    title: "How reminders work",
                    subtitle: "Servio calculates all future maintenance intervals and reminder projections based on your starting mileage.",
                    iconColor: .svOnTertiaryContainer,
                    background: .svSurfaceHigh.opacity(0.8)
                )
                .padding(.bottom, 16)

                syncNote
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .scrollDismissesKeyboard(.immediately)
        .background(.svSurface)
        .safeAreaInset(edge: .bottom) { saveBar }
        .if(!isEditing) { $0.wizardToolbar(step: 4, stepCount: 4) }
        .if(isEditing) { $0.navigationBarTitleDisplayMode(.inline) }
        .navigationBarBackButtonHidden(isSaving)
//        .toolbar {
//            ToolbarItemGroup(placement: .keyboard) {
//                Spacer()
//                Button("Done") {
//                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                }
//            }
//        }
        .onChange(of: odometer) { value in
            let digits = String(value.filter(\.isNumber).prefix(7))
            if digits != value { odometer = digits }
            saveError = nil
        }
        .onChange(of: unit) { [unit] newUnit in
            func convert(_ text: String) -> String {
                guard let value = Int(text) else { return text }
                return String(newUnit.value(fromKilometers: unit.kilometers(from: value)))
            }
            odometer = convert(odometer)
            lastServiceKMs = lastServiceKMs.mapValues(convert)
            originalKMs = originalKMs.mapValues(convert)
        }
        .onAppear(perform: prefillFromLastService)
    }

    private var vehicleCard: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(.svSurfaceHigh)
                .frame(width: 56, height: 36)
                .overlay {
                    if let imageURL = selection?.model.imageURL ?? (car.imageURL.isEmpty ? nil : car.imageURL) {
                        AppImage(type: .url(imageURL), contentMode: .fill)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(selection?.title ?? "\(car.manufacturer) \(car.model)")
                    .font(.svBody)
                    .fontWeight(.bold)
                    .foregroundStyle(.svOnSurface)
                Text(selection.map { "\($0.engine.name) • \($0.transmission.rawValue)" } ?? car.engine)
                    .font(.svLabel)
                    .foregroundStyle(.svOnSurfaceVariant)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            BadgeView(
                text: isEditing ? "SCHEDULE UPDATE" : "SCHEDULE SETUP",
                textFont: .svLabel,
                textColor: .svOnSurfaceVariant,
                backgroundColor: .svSurfaceHigh,
                verticalPadding: 4,
                horizontalPadding: 10
            )
            .fixedSize()
        }
        .padding(12)
        .cardSurface(cornerRadius: 12)
        .accessibilityElement(children: .combine)
    }

    private var baselineSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("1. Vehicle Baseline", badge: .required, caption: "Odometer & Service Date")

            HStack(spacing: 12) {
                IconCircleView(icon: .icDirectionsCar, diameter: 36, iconSize: 18)
                CustomTextFieldView(
                    placeholder: "e.g. Daily Commuter",
                    text: $nickname,
                    appearance: .inset,
                    title: "VEHICLE NICKNAME",
                    titleAccessory: .text("Optional"),
                    rules: [.maxLength(30)]
                )
            }
            .padding(14)
            .cardSurface(cornerRadius: 12)

            odometerCard
            serviceDateCard
        }
    }

    private var odometerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                requiredLabel("Current Odometer")
                Spacer(minLength: 8)
                SegmentedChoiceView(options: [.kilometers, .miles], selection: $unit, size: .compact) { $0.symbol }
                    .fixedSize()
                    .accessibilityLabel("Distance unit")
            }

            HStack(spacing: 12) {
                IconCircleView(icon: .icSpeed, background: .svSurfaceHigh, diameter: 36, iconSize: 20)
                TextField("Enter mileage", text: $odometer)
                    .font(.svNumberMd)
                    .foregroundStyle(.svOnSurface)
                    .keyboardType(.numberPad)
                    .focused($isOdometerFocused)
                    .accessibilityLabel("Current odometer reading")
                Text(unit.symbol.uppercased())
                    .font(.svTitle)
                    .foregroundStyle(.svOnSurfaceVariant)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(isOdometerFocused ? Color.svTertiaryContainer : .svOutlineVariant.opacity(0.6), lineWidth: 2)
            }
            .contentShape(Rectangle())
            .onTapGesture { isOdometerFocused = true }
        }
        .padding(16)
        .cardSurface(cornerRadius: 12)
    }

    private var serviceDateCard: some View {
        HStack(spacing: 12) {
            IconCircleView(icon: .icCalendarToday, diameter: 36, iconSize: 18)

            VStack(alignment: .leading, spacing: 8) {
                requiredLabel("Last Service Date")
                DatePickerField(title: "Last service date", date: $lastServiceDate)
            }
        }
        .padding(14)
        .cardSurface(cornerRadius: 12)
    }

    private func lastServiceKM(for item: MaintenanceModel) -> Binding<String> {
        Binding(
            get: { lastServiceKMs[item.maintenanceTypeID] ?? "" },
            set: {
                lastServiceKMs[item.maintenanceTypeID] = String($0.filter(\.isNumber).prefix(7))
                saveError = nil
            }
        )
    }

    private func mileageError(for item: MaintenanceModel) -> String? {
        let text = lastServiceKMs[item.maintenanceTypeID] ?? ""

        guard !text.isEmpty else {
            return item.isRequired ? "This field is required" : nil
        }

        guard let value = Int(text), value > 0 else {
            return "Enter a valid mileage"
        }

        guard let odometerValue else {
            return nil
        }

        guard value <= odometerValue else {
            return "Can't be more than the current odometer"
        }

        return nil
    }

    @ViewBuilder
    private var servicesSections: some View {
        if !requiredItems.isEmpty {
            servicesSection(
                "2. Critical Services",
                badge: .required,
                caption: requiredItems.count == 1 ? "1 Scheduled Item" : "\(requiredItems.count) Scheduled Items",
                items: requiredItems
            )
        }
        if !conditionalItems.isEmpty {
            servicesSection(
                requiredItems.isEmpty ? "2. Fluid & Wear Services" : "3. Fluid & Wear Services",
                badge: .optional,
                caption: "If fitted",
                items: conditionalItems
            )
        }
    }

    private func servicesSection(_ title: String, badge: SectionBadge, caption: String, items: [MaintenanceModel]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title, badge: badge, caption: caption)
            ForEach(items, id: \.maintenanceTypeID) { item in
                ServiceMileageRow(
                    icon: item.serviceIcon ?? .icBuild,
                    title: item.name,
                    interval: item.intervalText(in: unit),
                    lastServiceKM: lastServiceKM(for: item),
                    placeholder: odometerValue.map { $0.formatted() } ?? "Same as odometer",
                    unitSymbol: unit.symbol,
                    isRequired: item.isRequired,
                    errorMessage: mileageError(for: item)
                )
            }
        }
        .padding(.bottom, 24)
    }

    private var saveBar: some View {
        BottomActionBar {
            VStack(spacing: 10) {
                if let saveError {
                    Text(saveError)
                        .font(.svBodySm)
                        .foregroundStyle(.svError)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }

                CustomButtonView(config: .init(
                    title: isSaving ? "Saving…" : isEditing ? "Update Maintenance Schedule" : "Save Maintenance Schedule",
                    isEnabled: canSave,
                    isLoading: isSaving,
                    trailingImage: isSaving ? nil : .icCheckCircle,
                    trailingImageSize: 20,
                    titleFont: .svButton,
                    iconColor: .svOnTertiaryContainer,
                    cornerRadius: 12,
                    backgroundColor: .svTertiaryContainer
                ), action: save)
                .shadow(color: .black.opacity(0.08), radius: 2, y: 1)
            }
        }
    }

    private var syncNote: some View {
        HStack(spacing: 6) {
            Image(.icLock)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 12, height: 12)
                .accessibilityHidden(true)
            Text("Synced securely to your account")
                .font(.svLabel)
        }
        .foregroundStyle(.svOnSurfaceVariant.opacity(0.8))
        .frame(maxWidth: .infinity)
    }

    private enum SectionBadge {
        case required
        case optional
    }

    private func sectionHeader(_ title: String, badge: SectionBadge, caption: String?) -> some View {
        HStack(spacing: 8) {
            Text(title.uppercased())
                .font(.svSectionLabel)
                .tracking(0.6)
                .foregroundStyle(.svOnSurface)
                .lineLimit(1)
                .layoutPriority(1)
            BadgeView(
                text: badge == .required ? "REQUIRED" : "OPTIONAL",
                textFont: .svLabel,
                textColor: badge == .required ? .svOnTertiaryContainer : .svOnSurfaceVariant,
                backgroundColor: badge == .required ? .svTertiaryContainer.opacity(0.2) : .svSurfaceContainer,
                verticalPadding: 2,
                horizontalPadding: 8
            )
            .fixedSize()
            Spacer(minLength: 8)
            if let caption {
                Text(caption)
                    .font(.svLabel)
                    .foregroundStyle(.svOnSurfaceVariant)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .padding(.horizontal, 4)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }

    private func requiredLabel(_ title: String) -> some View {
        HStack(spacing: 6) {
            Text(title.uppercased())
                .font(.svLabel)
                .bold()
                .tracking(0.8)
                .foregroundStyle(.svOnSurface)
            Text("*")
                .font(.svLabel)
                .bold()
                .foregroundStyle(.svTertiaryContainer)
                .accessibilityLabel("Required")
        }
    }

    /// When editing, starts from what's saved: the car's current odometer, the most recent service date,
    /// and the odometer reading each service was last done at.
    private func prefillFromLastService() {
        guard isEditing, !hasPrefilled else { return }
        hasPrefilled = true
        if let km = CarOdometerStore.kilometers(for: car) {
            odometer = String(unit.value(fromKilometers: km))
        }
        lastServiceDate = car.maintenance.compactMap { $0.lastServiceDate.flatMap(Date.init(apiDay:)) }.max()
        originalDate = lastServiceDate
        for item in services {
            if let km = item.lastServiceKM {
                lastServiceKMs[item.maintenanceTypeID] = String(unit.value(fromKilometers: km))
            }
        }
        originalKMs = lastServiceKMs
    }

    /// A new car saves every service. An update saves only the services whose mileage changed, or all of them when the
    /// date changed, so updating just the odometer doesn't mark every service as done. An empty mileage means
    /// "done at the current odometer". The odometer itself is kept by `CarOdometerStore` until the API has a field for it.
    /// Editing also uses POST until the server has PATCH user-cars/{id}/maintenance (`UserCarsService.updateMaintenance`).
    private func save() {
        guard let odometerValue, let lastServiceDate, !isSaving else { return }
        let serviceDay = lastServiceDate.apiDay
        let dateChanged = serviceDay != originalDate?.apiDay
        let entries = services.filter(\.hasInterval).compactMap { item -> SaveMaintenanceRequest.Entry? in
            let text = lastServiceKMs[item.maintenanceTypeID] ?? ""
            guard !isEditing || dateChanged || text != (originalKMs[item.maintenanceTypeID] ?? "") else { return nil }
            return SaveMaintenanceRequest.Entry(
                maintenanceTypeID: item.maintenanceTypeID,
                lastServiceDate: serviceDay,
                lastServiceKM: unit.kilometers(from: Int(text) ?? odometerValue),
                notes: nil
            )
        }
        isOdometerFocused = false
        isSaving = true
        saveError = nil

        Task {
            do {
                if !entries.isEmpty {
                    try await userCars.saveMaintenance(carID: car.id, request: SaveMaintenanceRequest(maintenance: entries))
                }
                CarOdometerStore.save(unit.kilometers(from: odometerValue), forCarID: car.id)
                await userData.reloadCars()
                if isEditing {
                    dismiss()
                } else {
                    navigate.popToRoot()
                }
            } catch {
                saveError = error.localizedDescription
            }
            isSaving = false
        }
    }
}

#Preview {
    NavigationStack {
        MaintenancePageView(selection: NewCarSelection(
            manufacturer: Manufacturer(id: 1, name: "Toyota", iconURL: ""),
            model: ManufacturerModel(id: 1, manufacturerID: 1, name: "Camry", imageURL: nil, imageSourceURL: nil, sourceURL: nil, notes: nil),
            engine: ModelEngine(id: 1, modelID: 1, name: "2.5L I4", fuelType: "petrol", sourceURL: ""),
            transmission: .automatic
        ), car: CarModel.samples[0])
    }
    .environmentObject(UserDataStore.shared)
}
