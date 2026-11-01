//
//  EditProfilePageView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/11/01.
//

import PhotosUI
import SwiftUI

struct EditProfilePageView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var authStore: AuthStore
    @EnvironmentObject private var userData: UserDataStore

    @AppStorage(AppPreferences.prefersMilesKey) private var prefersMiles = false
    @AppStorage(AppPreferences.serviceAlertsKey) private var serviceAlertsEnabled = true

    @State private var fullname = ""
    @State private var email = ""
    @State private var unit = DistanceUnit.kilometers
    @State private var serviceAlerts = true
    @State private var isNameValid = true
    @State private var isEmailValid = true
    @State private var isChoosingPhotoSource = false
    @State private var isPickingPhoto = false
    @State private var isShowingCamera = false
    @State private var photoItem: PhotosPickerItem?
    @State private var pickedImage: UIImage?
    @State private var isSaving = false
    @State private var errorMessage: String?
    @State private var hasLoadedValues = false

    private var trimmedName: String {
        fullname.trimmingCharacters(in: .whitespaces)
    }

    private var trimmedEmail: String {
        email.trimmingCharacters(in: .whitespaces)
    }

    private var detailsChanged: Bool {
        trimmedName != userData.profile?.fullname || trimmedEmail != (userData.profile?.email ?? "")
    }

    private var hasChanges: Bool {
        detailsChanged
            || pickedImage != nil
            || unit != (prefersMiles ? .miles : .kilometers)
            || serviceAlerts != serviceAlertsEnabled
    }

    private var canSave: Bool {
        isNameValid && isEmailValid && hasChanges && !isSaving
    }

    private var primaryCarTitle: String? {
        userData.cars.first.map { "\($0.manufacturer) \($0.model)" }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                header
                    .padding(.bottom, 8)

                CustomTextFieldView(
                    placeholder: "Enter full name",
                    text: $fullname,
                    title: "FULL NAME",
                    icon: .icPerson,
                    rules: [.required("Enter your full name")],
                    isEnabled: !isSaving,
                    onValidationChange: { isNameValid = $0 }
                )
                .textContentType(.name)
                .textInputAutocapitalization(.words)

                CustomTextFieldView(
                    placeholder: "Enter email address",
                    text: $email,
                    title: "EMAIL ADDRESS",
                    icon: .icMail,
                    trailingIcon: isEmailValid && !trimmedEmail.isEmpty ? .icCheckCircle : nil,
                    rules: [.required("Enter your email address"), .email()],
                    isEnabled: !isSaving,
                    onValidationChange: { isEmailValid = $0 }
                )
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

                preferencesCard
                    .padding(.top, 8)

                actions
                    .padding(.top, 8)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 40)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(.svSurface)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("EDIT PROFILE")
                    .font(.svHeadlineMd)
                    .foregroundStyle(.svOnSurface)
                    .fixedSize()
                    .accessibilityAddTraits(.isHeader)
            }
            .hiddenSharedBackground()
        }
        .confirmationDialog("Change profile photo", isPresented: $isChoosingPhotoSource, titleVisibility: .visible) {
            Button("Take Photo") { isShowingCamera = true }
            Button("Choose from Library") { isPickingPhoto = true }
            Button("Cancel", role: .cancel) {}
        }
        .photosPicker(isPresented: $isPickingPhoto, selection: $photoItem, matching: .images)
        .fullScreenCover(isPresented: $isShowingCamera) {
            CameraPicker { image in
                pickedImage = image
                errorMessage = nil
            }
            .ignoresSafeArea()
        }
        .onChange(of: photoItem) { item in
            Task { await loadPhoto(item) }
        }
        .onChange(of: fullname) { _ in errorMessage = nil }
        .onChange(of: email) { _ in errorMessage = nil }
        .onAppear(perform: loadValues)
    }

    private var header: some View {
        VStack(spacing: 4) {
            ProfileAvatarView(
                imageURL: userData.profile?.imageURL,
                previewImage: pickedImage,
                onTapCamera: changePhoto
            )
            .overlay {
                if isSaving && pickedImage != nil {
                    Circle()
                        .fill(.black.opacity(0.4))
                        .overlay { ProgressView().tint(.white) }
                        .accessibilityLabel("Uploading photo")
                }
            }
            .disabled(isSaving)
            .padding(.bottom, 8)

            Text(trimmedName.isEmpty ? userData.profile?.fullname ?? "" : trimmedName)
                .font(.svHeadlineMd)
                .foregroundStyle(.svOnSurface)

            if let username = authStore.session?.user.username {
                HStack(spacing: 4) {
                    Image(.icVerifiedUser)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                        .foregroundStyle(.svTertiary)
                        .accessibilityHidden(true)
                    Text("@\(username)")
                        .font(.svLabel)
                        .foregroundStyle(.svOnSurfaceVariant)
                }
            }

            if let primaryCarTitle {
                HStack(spacing: 8) {
                    Image(.icDirectionsCar)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.svTertiary)
                        .accessibilityHidden(true)
                    Text("Primary: \(primaryCarTitle)")
                        .font(.svLabel)
                        .foregroundStyle(.svOnSurface)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.svSurfaceHigh, in: Capsule())
                .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var preferencesCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(.icTune)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.svTertiary)
                    .accessibilityHidden(true)
                Text("Preferences")
                    .font(.svTitle)
                    .foregroundStyle(.svOnSurface)
                    .accessibilityAddTraits(.isHeader)
            }

            HStack(spacing: 12) {
                preferenceLabel("Odometer & Units", detail: "Default measurement system")
                Spacer(minLength: 8)
                SegmentedChoiceView(options: [.miles, .kilometers], selection: $unit, size: .compact) {
                    $0 == .miles ? "Miles" : "KM"
                }
                .fixedSize()
                .accessibilityLabel("Distance unit")
            }

            Toggle(isOn: $serviceAlerts) {
                preferenceLabel("Service Alerts", detail: "Timely oil, brake, & tire checks")
            }
            .tint(.svTertiaryContainer)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface(cornerRadius: 12)
    }

    private func preferenceLabel(_ title: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.svBody)
                .foregroundStyle(.svOnSurface)
            Text(detail)
                .font(.svLabel)
                .foregroundStyle(.svOnSurfaceVariant)
        }
    }

    private var actions: some View {
        VStack(spacing: 8) {
            if let errorMessage {
                Text(errorMessage)
                    .font(.svBodySm)
                    .foregroundStyle(.svError)
                    .multilineTextAlignment(.center)
            }

            CustomButtonView(config: .init(
                title: isSaving ? "Saving…" : "Save Changes",
                isEnabled: canSave,
                isLoading: isSaving,
                leadingImage: isSaving ? nil : .icCheck,
                leadingImageSize: 20,
                titleFont: .svButton,
                iconColor: .svOnTertiaryContainer,
                cornerRadius: 12,
                backgroundColor: .svTertiaryContainer
            ), action: save)
            .shadow(color: .black.opacity(0.08), radius: 2, y: 1)

            Button("Cancel") { dismiss() }
                .font(.svButton)
                .foregroundStyle(.svOnSurfaceVariant)
                .frame(maxWidth: .infinity, minHeight: 48)
                .disabled(isSaving)
        }
    }

    private func loadValues() {
        guard !hasLoadedValues else { return }
        hasLoadedValues = true
        fullname = userData.profile?.fullname ?? ""
        email = userData.profile?.email ?? ""
        unit = prefersMiles ? .miles : .kilometers
        serviceAlerts = serviceAlertsEnabled
    }

    private func changePhoto() {
        if CameraPicker.isAvailable {
            isChoosingPhotoSource = true
        } else {
            isPickingPhoto = true
        }
    }

    private func loadPhoto(_ item: PhotosPickerItem?) async {
        guard let item else { return }
        photoItem = nil
        guard let data = try? await item.loadTransferable(type: Data.self), let image = UIImage(data: data) else {
            errorMessage = "That photo couldn't be loaded. Try another one."
            return
        }
        pickedImage = image
        errorMessage = nil
    }

    private func save() {
        guard canSave else { return }
        let photoData = pickedImage?.jpegDataForUpload()
        if pickedImage != nil, photoData == nil {
            errorMessage = "That photo couldn't be prepared for upload. Try another one."
            return
        }
        let details = detailsChanged ? UpdateProfileRequest(fullname: trimmedName, email: trimmedEmail) : nil
        isSaving = true
        errorMessage = nil

        Task {
            let result = await userData.saveProfile(details: details, photo: photoData)
            if photoData != nil, result.photoError == nil {
                pickedImage = nil
            }
            if let error = result.firstError {
                errorMessage = message(for: error)
            } else {
                prefersMiles = unit == .miles
                serviceAlertsEnabled = serviceAlerts
                await NotificationManager.shared.updateBadge(for: userData.cars)
                dismiss()
            }
            isSaving = false
        }
    }

    private func message(for error: Error) -> String {
        if case NetworkError.server(statusCode: 409) = error {
            return "That email address is already in use."
        }
        return error.localizedDescription
    }
}

#Preview {
    NavigationStack {
        EditProfilePageView()
    }
    .environmentObject(AuthStore.shared)
    .environmentObject(UserDataStore.shared)
}
