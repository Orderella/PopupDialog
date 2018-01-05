//
//  TrackingMode.swift
//  DynamicBlurView
//
//  Created by Kyohei Ito on 2017/08/17.
//  Copyright © 2017年 kyohei_ito. All rights reserved.
//

public enum TrackingMode: CustomStringConvertible {
    case tracking
    case common
    case none

    public var description: String {
        switch self {
        case .tracking:
            return RunLoopMode.UITrackingRunLoopMode.rawValue
        case .common:
            return RunLoopMode.commonModes.rawValue
        case .none:
            return ""
        }
    }
}

