//
//  AppImage.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/28.
//

import SwiftUI

enum ImageType: Hashable {
    case url(String)
    case local(ImageResource)
}

extension ImageType {

    var url: URL? {
        switch self {
        case .url(let string):
            // Uploaded files come back as paths like "/uploads/...", relative to the API's host.
            return URL(string: string, relativeTo: APIConfig.baseURL)?.absoluteURL

        case .local:
            return nil
        }
    }
}

struct AppImage: View {

    let type: ImageType

    var placeholder: WebImageLoader.PlaceHolder = .error(.default)
    var imageSize: ((CGSize) -> Void)?
    var isResizable: Bool = true
    var contentMode: ContentMode = .fit
    var tintColor: Color?

    var body: some View {
        content
    }

    @ViewBuilder
    private var content: some View {
        switch type {
        case .local(let resource):
            localImage(resource)

        case .url:
            remoteImage
        }
    }

    @ViewBuilder
    private func localImage(_ resource: ImageResource) -> some View {
        let image = Image(resource)

        if isResizable {
            configuredImage(image.resizable())
        } else {
            configuredImage(image)
        }
    }

    @ViewBuilder
    private func configuredImage(_ image: Image) -> some View {
        if let tintColor {
            image
                .renderingMode(.template)
                .foregroundStyle(tintColor)
        } else {
            image
                .renderingMode(.original)
        }
    }

    private var remoteImage: some View {
        WebImageLoader(
            url: type.url,
            errorView: placeholder,
            imageSize: imageSize
        )
        .aspectRatio(contentMode: contentMode)
    }
}
