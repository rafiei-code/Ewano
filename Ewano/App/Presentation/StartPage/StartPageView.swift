//
//  StartPageView.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/26.
//

import SwiftUI

struct StartPageView: View {
    var onFeatureTap: () -> Void = {}

    private let slides = StartSlide.all
    private static let autoAdvanceDelay: Duration = .seconds(3)

    /// Unbounded page counter, so the carousel loops in both directions.
    @State private var position = 0
    @State private var dragOffset: CGFloat = 0
    @State private var controlsHeight: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.navigate) private var navigate

    private var currentSlide: Int {
        slideIndex(for: position)
    }

    private var autoAdvanceID: Int? {
        dragOffset == 0 && !reduceMotion ? position : nil
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                carousel(bottomInset: proxy.safeAreaInsets.bottom + controlsHeight)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    BrandBadge()
                        .padding(.top, 16)

                    Spacer(minLength: 0)

                    bottomControls
                        .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { controlsHeight = $0 }
                }
                .padding(.horizontal, 20)
            }
        }
        .background(.svInverseSurface)
        .task(id: autoAdvanceID) {
            guard let autoAdvanceID else { return }
            do {
                try await Task.sleep(for: Self.autoAdvanceDelay)
            } catch {
                return
            }
            withAnimation(.easeInOut(duration: 0.6)) {
                position = autoAdvanceID + 1
            }
        }
    }

    private func carousel(bottomInset: CGFloat) -> some View {
        GeometryReader { proxy in
            let pageWidth = proxy.size.width
            ZStack {
                ForEach(position - 1...position + 1, id: \.self) { index in
                    slidePage(slides[slideIndex(for: index)], bottomInset: bottomInset)
                        .frame(width: pageWidth)
                        .offset(x: CGFloat(index - position) * pageWidth + dragOffset)
                }
            }
            .contentShape(Rectangle())
            .gesture(swipeGesture(pageWidth: pageWidth))
        }
    }

    private func swipeGesture(pageWidth: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { dragOffset = $0.translation.width }
            .onEnded { value in
                let travel = value.predictedEndTranslation.width
                withAnimation(.easeOut(duration: 0.3)) {
                    if travel < -pageWidth / 2 {
                        position += 1
                    } else if travel > pageWidth / 2 {
                        position -= 1
                    }
                    dragOffset = 0
                }
            }
    }

    private func slideIndex(for position: Int) -> Int {
        (position % slides.count + slides.count) % slides.count
    }

    private func slidePage(_ slide: StartSlide, bottomInset: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Spacer(minLength: 0)

            HighlightTag(title: slide.tag)

            Text(slide.title)
                .font(.svDisplay)
                .tracking(-0.44)
                .tightLineHeight()
                .foregroundStyle(.svInverseOnSurface)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)

            Text(slide.description)
                .font(.svBody)
                .foregroundStyle(.svOutlineVariant)
                .frame(maxWidth: 384, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.bottom, bottomInset + 16)
        .background { slideBackground(slide.image) }
        .clipped()
    }

    private var bottomControls: some View {
        VStack(alignment: .leading, spacing: 0) {
            PageIndicator(pageCount: slides.count, currentPage: currentSlide)
                .padding(.bottom, 28)

            FeatureHighlightRow(
                icon: .icVerified,
                title: "OEM Precision",
                subtitle: "Factory scheduled intervals",
                onTap: onFeatureTap
            )
            .padding(.bottom, 16)

            actions
        }
        .padding(.bottom, 28)
    }

    private var actions: some View {
        VStack(spacing: 12) {
            CustomButtonView(config: .init(
                title: "GET STARTED",
                trailingImage: .icArrowForward,
                trailingImageSize: 20,
                titleColor: .svOnTertiaryFixed,
                titleFont: .svButton,
                titleTracking: 0.85,
                iconColor: .svOnTertiaryFixed,
                cornerRadius: 12,
                backgroundColor: .svTertiaryFixed
            )) {
                navigate(to: .signUp)
            }
            .shadow(color: .black.opacity(0.2), radius: 8, y: 4)

            HStack(spacing: 4) {
                Text("Already have an account?")
                    .foregroundStyle(.svInverseOnSurface.opacity(0.80))
                Button("Log in") { navigate(to: .login) }
                    .bold()
                    .foregroundStyle(.svTertiaryFixed)
            }
            .font(.svBodySm)
            .padding(.vertical, 4)
        }
    }

    private func slideBackground(_ image: ImageResource) -> some View {
        Image(image)
            .resizable()
            .scaledToFill()
            .overlay {
                LinearGradient(
                    colors: [
                        .svInverseSurface.opacity(0.40),
                        .svInverseSurface.opacity(0.75),
                        .svInverseSurface
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .overlay(alignment: .bottom) {
                GeometryReader { geometry in
                    LinearGradient(
                        colors: [.clear, .svInverseSurface.opacity(0.90), .svInverseSurface],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: geometry.size.height * 0.8)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
            .accessibilityHidden(true)
    }
}

#Preview {
    StartPageView()
}

private extension Text {
    @ViewBuilder
    func tightLineHeight() -> some View {
        if #available(iOS 26.0, *) {
            lineHeight(.multiple(factor: 1.0))
        } else {
            self
        }
    }
}
