//
//  UIImage+Blur.swift
//  DynamicBlurView
//
//  Created by Kyohei Ito on 2017/08/11.
//  Copyright © 2017年 kyohei_ito. All rights reserved.
//

import UIKit

public extension UIImage {
    func blurred(radius: CGFloat, iterations: Int, ratio: CGFloat, blendColor color: UIColor?, blendMode mode: CGBlendMode) -> UIImage? {
        guard let cgImage = cgImage else {
            return nil
        }

        if cgImage.area <= 0 || radius <= 0 {
            return self
        }

        var boxSize = UInt32(radius * scale * ratio)
        if boxSize % 2 == 0 {
            boxSize += 1
        }

        return cgImage.blurred(with: boxSize, iterations: iterations, blendColor: color, blendMode: mode).map {
            UIImage(cgImage: $0, scale: scale, orientation: imageOrientation)
        }
    }
}
