//
//  SplashPageView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/31.
//

import SwiftUI

/// Runs the launch requests and then hands over with `onFinish`; the app root decides where to go next.
struct SplashPageView: View {
    var minimumDuration: Duration = .seconds(3)
    let onFinish: () -> Void

    private static let steps = [
        "Loading your garage...",
        "Checking upcoming services...",
        "Verifying service logs...",
        "Garage ready"
    ]
    private static let stepDuration: Duration = .seconds(2.2)

    @EnvironmentObject private var authStore: AuthStore
    @EnvironmentObject private var userData: UserDataStore
    @State private var step = 0

    private var versionText: String {
        "Ewano v\(Bundle.main.appVersion)  •  Build \(Bundle.main.buildNumber)"
    }

    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.top, 24)

            Spacer(minLength: 16)

            // The loader canvas leaves room for its pulse, so trim it back to the gauge's footprint.
            GaugeLoaderView()
                .padding(.vertical, -24)

            status
                .padding(.top, 32)

            Spacer(minLength: 16)

            footer
                .padding(.bottom, 16)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background { background }
        .task { await prepare() }
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: Self.stepDuration)
                withAnimation(.easeOut(duration: 0.3)) {
                    step = (step + 1) % Self.steps.count
                }
            }
        }
    }

    // Waits for both the requests and `minimumDuration`, whichever takes longer.
    private func prepare() async {
        let start = ContinuousClock.now
        authStore.dropExpiredSession()
        if authStore.session != nil {
            await userData.load()
            if userData.phase == .loaded {
                await NotificationManager.shared.notifyOverdueServices(in: userData.cars)
            }
        }
        try? await Task.sleep(until: start + minimumDuration, clock: .continuous)
        guard !Task.isCancelled else { return }
        onFinish()
    }

    private var header: some View {
        VStack(spacing: 0) {
            Image(.icServioEmblem)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundStyle(.svTertiaryFixed)
                .frame(width: 56, height: 56)
                .background(.svSurfaceHighest.opacity(0.2), in: RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.25), radius: 25, y: 12)
                .padding(.bottom, 16)
                .accessibilityHidden(true)

            Text("Ewano")
                .font(.svHeadlineMobile)
                .tracking(2.8)
                .foregroundStyle(.svInverseOnSurface)
                .shadow(color: .black.opacity(0.3), radius: 3, y: 2)
                .accessibilityAddTraits(.isHeader)

            HStack(spacing: 8) {
                PingingDot(size: 6, color: .svTertiaryFixedDim, showsCore: false)
                Text("PRECISION VEHICLE CARE")
                    .font(.svLabel)
                    .tracking(3.64)
                    .foregroundStyle(.svTertiaryFixed.opacity(0.95))
            }
            .padding(.top, 6)
        }
    }

    private var status: some View {
        VStack(spacing: 0) {
            Text(Self.steps[step])
                .font(.svTitle)
                .tracking(0.45)
                .foregroundStyle(.svInverseOnSurface)
                .id(step)
                .transition(.opacity)

            HStack(spacing: 6) {
                ForEach(Self.steps.indices, id: \.self) { index in
                    Capsule()
                        .fill(index <= step ? AnyShapeStyle(.svTertiaryFixed) : AnyShapeStyle(.svSurfaceVariant.opacity(0.3)))
                        .frame(width: 24, height: 4)
                }
            }
            .padding(.top, 12)
            .accessibilityHidden(true)

            Text("Connecting to private garage network")
                .font(.svBodySm)
                .foregroundStyle(.svOutlineVariant.opacity(0.8))
                .padding(.top, 8)
        }
        .multilineTextAlignment(.center)
    }

    private var footer: some View {
        VStack(spacing: 12) {
//            HStack(spacing: 8) {
//                PingingDot(size: 8, color: .svTertiaryFixed, showsCore: true)
//                Text("ENCRYPTED OBD-II LINK ACTIVE")
//                    .font(.svLabel)
//                    .tracking(0.33)
//                    .foregroundStyle(.svInverseOnSurface.opacity(0.9))
//            }
//            .padding(.horizontal, 14)
//            .padding(.vertical, 6)
//            .background(.svInverseSurface.opacity(0.8), in: Capsule())

            Text(versionText)
                .font(.svLabel)
                .tracking(0.65)
                .foregroundStyle(.svOutlineVariant.opacity(0.7))
        }
    }

    private var background: some View {
        ZStack(alignment: .top) {
            Image(.imgSplashGarage)
                .resizable()
                .scaledToFill()
                .colorMultiply(Color(white: 0.9))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()

            LinearGradient(
                colors: [
                    .svInverseSurface.opacity(0.95),
                    .svInverseSurface.opacity(0.65),
                    .svInverseSurface.opacity(0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            Ellipse()
                .fill(.svTertiaryFixedDim.opacity(0.1))
                .frame(width: 384, height: 192)
                .blur(radius: 64)
                .offset(y: -96)
        }
        .background(.svInverseSurface)
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}

/// A dot whose halo keeps expanding and fading, like the design's `animate-ping`.
private struct PingingDot: View {
    let size: CGFloat
    let color: Color
    let showsCore: Bool

    @State private var isExpanded = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .opacity(isExpanded ? 0 : 0.75)
                .scaleEffect(isExpanded ? 2 : 1)
            if showsCore {
                Circle().fill(color)
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeOut(duration: 1).repeatForever(autoreverses: false)) {
                isExpanded = true
            }
        }
        .accessibilityHidden(true)
    }
}

#Preview {
    SplashPageView {}
        .environmentObject(AuthStore.shared)
        .environmentObject(UserDataStore.shared)
}
