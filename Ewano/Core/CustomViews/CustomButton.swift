//
//  CustomButton.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/24.
//

import SwiftUI
import Lottie

struct CustomButtonView: View {

    enum ShapeType {
        case circle
        case square
    }

    enum ButtonStyle {
        case danger
        case disabled
        case enabled
    }

    enum CustomButtonVariant {
        case filled
        case plain
    }

    enum SizeType {
        case full
        case normal
    }

    struct Config {
        let title: String?
        let style: ButtonStyle?
        let isEnabled: Bool
        let isLoading: Bool
        let leadingImage: ImageResource?
        let trailingImage: ImageResource?
        let leadingImageSize: CGFloat?
        let trailingImageSize: CGFloat?
        let titleColor: Color?
        let titleFont: Font?
        let titleTracking: CGFloat
        let iconColor: Color?
        let cornerRadius: CGFloat
        let backgroundColor: Color?
        let variant: CustomButtonVariant?
        let size: SizeType?
        let shape: ShapeType?

        init(
            title: String? = nil,
            style: ButtonStyle? = .enabled,
            isEnabled: Bool = true,
            isLoading: Bool = false,
            leadingImage: ImageResource? = nil,
            trailingImage: ImageResource? = nil,
            leadingImageSize: CGFloat? = 16,
            trailingImageSize: CGFloat? = 16,
            titleColor: Color? = nil,
            titleFont: Font? = .title,
            titleTracking: CGFloat = 0,
            iconColor: Color? = nil,
            cornerRadius: CGFloat = 16,
            backgroundColor: Color? = nil,
            variant: CustomButtonVariant? = .filled,
            size: SizeType? = .full,
            shape: ShapeType? = .square
        ) {
            self.title = title
            self.style = style
            self.isEnabled = isEnabled
            self.isLoading = isLoading
            self.leadingImage = leadingImage
            self.trailingImage = trailingImage
            self.leadingImageSize = leadingImageSize
            self.trailingImageSize = trailingImageSize
            self.titleColor = titleColor
            self.titleFont = titleFont
            self.titleTracking = titleTracking
            self.iconColor = iconColor
            self.cornerRadius = cornerRadius
            self.backgroundColor = backgroundColor
            self.variant = variant
            self.size = size
            self.shape = shape
        }
    }

    let config: Config
    var action: () -> Void

    var body: some View {
        HStack(spacing: 4) {

            if config.size == .full {
                Spacer()
            }

            if let leadingImage = config.leadingImage {
                Image(leadingImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: config.leadingImageSize, height: config.leadingImageSize)
                    .padding(.trailing, 0)
                    .foregroundStyle(config.iconColor ?? iconColor)
            }

            if let title = config.title {
                Text(title)
                    .font(config.titleFont)
                    .tracking(config.titleTracking)
                    .foregroundStyle(config.titleColor ?? titleColor)
            }

            if let trailingImage = config.trailingImage {
                Image(trailingImage)
                    .resizable()
                    .frame(width: config.trailingImageSize, height: config.trailingImageSize)
                    .padding(.leading, 8)
                    .foregroundStyle(config.iconColor ?? iconColor)
            }

            if config.size == .full {
                Spacer()
            }
        }
        .padding(config.variant == .plain ? 0 : 16)        .background {
            if config.variant == .filled {
                if config.shape == .square {
                    RoundedRectangle(cornerRadius: config.cornerRadius)
                        .fill(config.backgroundColor ?? backgroundColor)
                        .overlay {
                            if !config.isEnabled {
                                RoundedRectangle(cornerRadius: config.cornerRadius)
                                    .fill(.black.opacity(0.4))
                            }
                        }
                } else {
                    Circle()
                        .fill(config.backgroundColor ?? backgroundColor)
                        .overlay {
                            if !config.isEnabled {
                                RoundedRectangle(cornerRadius: config.cornerRadius)
                                    .fill(.black.opacity(0.4))
                            }
                        }
                }
            }
        }
        .overlay {
            HStack {
                if config.isLoading && config.variant == .plain {
                    LottieView(animation: .loader)
                        .playing(loopMode: .loop)
                        .frame(width: 50, height: 50)
                        .padding(.horizontal)
                }
                Spacer()
            }
        }
        .onTapGesture {
            if config.isEnabled && !config.isLoading {
                action()
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .disabled(!config.isEnabled || config.isLoading)
    }

    var backgroundColor: Color {
        switch config.style {
        case .danger:
            return .svError
        case .disabled:
            return .svOnTertiaryContainer
        case .enabled:
            return .svTertiaryFixedDim
        default:
            return .clear
        }
    }

    var iconColor: Color {
        switch config.style {
        case .danger:
            return .white
        case .disabled:
            return .svOnTertiaryFixed
        case .enabled:
            return .svTertiary
        default:
            return .clear
        }
    }

    var titleColor: Color {
        switch config.style {
        case .danger:
            return .white
        case .disabled:
            return .svOnTertiaryFixed
        case .enabled:
            return .svOnTertiaryContainer
        default:
            return .clear
        }
    }
}

#Preview {
    VStack {
        CustomButtonView(config: .init(title: "ok", style: .danger, isEnabled: false, trailingImage: .icCheckCircle, trailingImageSize: 24, size: .full)) {

        }
        .padding()

        CustomButtonView(config: .init(title: "ok", style: .disabled, isEnabled: true, trailingImage: .icCheckCircle, trailingImageSize: 24, size: .full)) {

        }
        .padding()

        CustomButtonView(config: .init(title: "ok", style: .enabled, isEnabled: true, isLoading: true, trailingImage: .icCheckCircle, trailingImageSize: 24, size: .full)) {

        }
        .padding()
    }
}
