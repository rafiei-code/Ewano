//
//  UIImageExtension.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/11/01.
//

import UIKit

extension UIImage {
    /// A JPEG of at most `maxBytes`. Quality is lowered first, then the image is shrunk until it fits.
    func jpegDataForUpload(maxBytes: Int = 500_000, maxDimension: CGFloat = 1024) -> Data? {
        var dimension = maxDimension
        while dimension >= 160 {
            let image = resized(maxDimension: dimension)
            for quality in stride(from: 0.8, through: 0.3, by: -0.1) {
                if let data = image.jpegData(compressionQuality: quality), data.count <= maxBytes {
                    return data
                }
            }
            dimension *= 0.75
        }
        return nil
    }

    private func resized(maxDimension: CGFloat) -> UIImage {
        let scale = min(1, maxDimension / max(size.width, size.height))
        let targetSize = CGSize(width: size.width * scale, height: size.height * scale)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return UIGraphicsImageRenderer(size: targetSize, format: format).image { _ in
            draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
