//
//  CaptureQuality.swift
//  DynamicBlurView
//
//  Created by Kyohei Ito on 2017/08/17.
//  Copyright © 2017年 kyohei_ito. All rights reserved.
//

import UIKit

public enum CaptureQuality {
    case `default`
    case low
    case medium
    case high

    var imageScale: CGFloat {
        switch self {
        case .default, .high:
            return 0
        case .low, .medium:
            return  1
        }
    }

    var interpolationQuality: CGInterpolationQuality {
        switch self {
        case .default, .low:
            return .none
        case .medium, .high:
            return .default
        }
    }
}
