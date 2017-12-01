//
//  UIView+Animations.swift
//
//  Copyright (c) 2016 Orderella Ltd. (http://orderella.co.uk)
//  Author - Martin Wildfeuer (http://www.mwfire.de)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import UIKit

/*!
 The intended direction of the animation
 - in:  Animate in
 - out: Animate out
 */
internal enum AnimationDirection {
    case `in` // swiftlint:disable:this identifier_name
    case out
}

internal extension UIView {

    /// The key for the fade animation
    internal var fadeKey: String { return "FadeAnimation" }
    internal var shakeKey: String { return "ShakeAnimation" }

    internal func pv_fade(_ direction: AnimationDirection, _ value: Float, duration: CFTimeInterval = 0.08) {
        layer.removeAnimation(forKey: fadeKey)
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = duration
        animation.fromValue = layer.presentation()?.opacity
        layer.opacity = value
        animation.fillMode = kCAFillModeForwards
        layer.add(animation, forKey: fadeKey)
    }

    internal func pv_layoutIfNeededAnimated(duration: CFTimeInterval = 0.08) {
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    // As found at https://gist.github.com/mourad-brahim/cf0bfe9bec5f33a6ea66#file-uiview-animations-swift-L9
    // Slightly modified
    internal func pv_shake() {
        layer.removeAnimation(forKey: shakeKey)
        let vals: [Double] = [-2, 2, -2, 2, 0]
        
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        translation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        translation.values = vals
        
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = vals.map { (degrees: Double) in
            let radians: Double = (Double.pi * degrees) / 180.0
            return radians
        }
        
        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [translation, rotation]
        shakeGroup.duration = 0.3
        self.layer.add(shakeGroup, forKey: shakeKey)
    }
}
