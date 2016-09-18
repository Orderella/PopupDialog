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
    case `in`
    case out
}

internal extension UIView {

    /// The key for the fade animation
    internal var fadeKey: String { return "FadeAnimation" }

    /*!
     Applies a fade animation to this view
     - parameter direction: Animation direction
     - parameter value:     The end value of this animation
     - parameter duration:  The duration of this animation
     */
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
}
