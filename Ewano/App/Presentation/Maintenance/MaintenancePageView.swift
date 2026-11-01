//
//  MaintenancePageView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import SwiftUI

struct MaintenancePageView: View {
    let selection: NewCarSelection
    let car: CarModel
    var userCars: UserCarsService = Services.shared.userCars

    @Environment(\.navigate) private var navigate
    @EnvironmentObject private var userData: UserDataStore
    @State private var nickname = ""
    @State private var odometer = ""
    @State private var unit = DistanceUnit.kilometers
    @State private var lastServiceDate: Date?
    @State private var pickerDate = Date.now
    @State private var isPickingDate = false
    @State private var intervals: [Int: String] = [:]
    @State private var isSaving = false
    @State private var saveError: String?
    @FocusState private var isOdometerFocused: Bool

    private var odometerValue: Int? {
        Int(odometer)
    }

    private var requiredItems: [MaintenanceModel] {
        car.maintenance.filter(\.isRequired)
    }

    private var conditionalItems: [MaintenanceModel] {
        car.maintenance.filter(\.isConditional)
    }

    private var canSave: Bool {
        odometerValue != nil
            && lastServiceDate != nil
            && requiredItems.allSatisfy { !interval(for: $0).wrappedValue.trimmingCharacters(in: .whitespaces).isEmpty }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    AccentTitleView(title: "Setup maintenance schedule")
                    Text("Configure baseline mileage & service intervals for your vehicle.")
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
                .padding(.bottom, 32)

                saveButton
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(.svSurface)
        .wizardToolbar(step: 4, stepCount: 4)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { isOdometerFocused = false }
            }
        }
        .sheet(isPresented: $isPickingDate) {
            datePickerSheet
        }
        .onChange(of: odometer) { value in
            let digits = String(value.filter(\.isNumber).prefix(7))
            if digits != value { odometer = digits }
            saveError = nil
        }
    }

    private var vehicleCard: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(.svSurfaceHigh)
                .frame(width: 56, height: 36)
                .overlay {
                    if let imageURL = selection.model.imageURL {
                        AppImage(type: .url(imageURL), contentMode: .fill)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(selection.title)
                    .font(.svBody)
                    .fontWeight(.bold)
                    .foregroundStyle(.svOnSurface)
                Text("\(selection.engine.name) • \(selection.transmission.rawValue)")
                    .font(.svLabel)
                    .foregroundStyle(.svOnSurfaceVariant)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            BadgeView(
                text: "SCHEDULE SETUP",
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
                Button {
                    pickerDate = lastServiceDate ?? .now
                    isPickingDate = true
                } label: {
                    HStack {
                        Text(lastServiceDate?.formatted(date: .abbreviated, time: .omitted) ?? "Select date")
                            .font(.svBody)
                            .fontWeight(.semibold)
                            .foregroundStyle(lastServiceDate == nil ? .svOutline : .svOnSurface)
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
                .accessibilityLabel("Last service date")
                .accessibilityValue(lastServiceDate?.formatted(date: .long, time: .omitted) ?? "Not set")
            }
        }
        .padding(14)
        .cardSurface(cornerRadius: 12)
    }

    private var datePickerSheet: some View {
        VStack(spacing: 16) {
            DatePicker("Last service date", selection: $pickerDate, in: ...Date.now, displayedComponents: .date)
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
                lastServiceDate = pickerDate
                isPickingDate = false
            }
        }
        .padding(20)
        .presentationDetents([.medium, .large])
    }

    private func interval(for item: MaintenanceModel) -> Binding<String> {
        Binding(
            get: { intervals[item.maintenanceTypeID] ?? "" },
            set: { intervals[item.maintenanceTypeID] = $0 }
        )
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
                MaintenanceIntervalRow(
                    icon: item.serviceIcon ?? .icBuild,
                    title: item.name,
                    interval: interval(for: item),
                    placeholder: "e.g. \(item.intervalText(in: unit))",
                    isRequired: item.isRequired
                )
            }
        }
        .padding(.bottom, 24)
    }

    private var saveButton: some View {
        VStack(spacing: 12) {
            if let saveError {
                Text(saveError)
                    .font(.svBodySm)
                    .foregroundStyle(.svError)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }

            CustomButtonView(config: .init(
                title: isSaving ? "Saving…" : "Save Maintenance Schedule",
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
        }
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

    // The API has no fields for the nickname or the intervals yet, so only the odometer and date are sent.
    private func save() {
        guard let odometerValue, let lastServiceDate, !isSaving else { return }
        let serviceDay = lastServiceDate.formatted(Date.ISO8601FormatStyle(timeZone: .current).year().month().day())
        let request = SaveMaintenanceRequest(maintenance: car.maintenance.filter(\.hasInterval).map {
            SaveMaintenanceRequest.Entry(
                maintenanceTypeID: $0.maintenanceTypeID,
                lastServiceDate: serviceDay,
                lastServiceKM: unit.kilometers(from: odometerValue),
                notes: nil
            )
        })
        isOdometerFocused = false
        isSaving = true
        saveError = nil

        Task {
            do {
                try await userCars.saveMaintenance(carID: car.id, request: request)
                await userData.reloadCars()
                navigate.popToRoot()
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
