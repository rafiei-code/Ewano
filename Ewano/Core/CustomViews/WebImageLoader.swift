//
//  WebImageLoader.swift
//  Ewano
//
//  Created by Abolfazl on 2026/10/28.
//

import SwiftUI
import SDWebImageSwiftUI

struct WebImageLoader: View {

    var url: URL?
    var errorView: PlaceHolder = .error(.default)
    var imageSize: ((CGSize) -> ())? = nil
    @State private var isFailed: Bool = false

    var body: some View {

        if url == nil {
            errorView.view
        } else {
            WebImage(url: url) { image in
                withAnimation {
                    image
                        .resizable()
                        .scaledToFit()
                }
            } placeholder: {
                if isFailed {
                    errorView.view
                }
            }
            .onSuccess(perform: { image, data, cachType in
                imageSize?(image.size)
            })
            .onFailure { error in
                self.isFailed = true
            }
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
        }
    }
}

extension WebImageLoader {
    enum PlaceHolder {
        case error(View)
        case none

        var view: AnyView {
            switch self {
            case .error(let customView):
                switch customView {
                case .default:
                    AnyView(VStack {
                        Image(.icWarning)
                            .font(.system(size: 30))
                            .foregroundColor(.gray)
                    })
                case .custom(let view):
                    AnyView(view)
                }
            case .none:
                AnyView(EmptyView())
            }
        }
    }
}

extension WebImageLoader.PlaceHolder {
    enum View {
        case `default`
        case custom(any SwiftUI.View)
    }
}

#Preview {
    WebImageLoader(
        url: URL(string: "https://sitechecker.pro/wp-content/uploads/2023/05/URL-meaning.jpg"))
    .scaledToFit()
}
