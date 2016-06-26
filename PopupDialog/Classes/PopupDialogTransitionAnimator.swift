//
//  PopupDialogTransitionAnimator.swift
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

/// Base class for custom transition animations
internal class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var to: UIViewController!
    var from: UIViewController!
    let inDuration: NSTimeInterval
    let outDuration: NSTimeInterval
    let direction: AnimationDirection

    init(inDuration: NSTimeInterval, outDuration: NSTimeInterval, direction: AnimationDirection) {
        self.inDuration = inDuration
        self.outDuration = outDuration
        self.direction = direction
        super.init()
    }

    internal func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return direction == .In ? inDuration : outDuration
    }

    internal func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        switch direction {
        case .In:
            to = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
            from = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
            let container = transitionContext.containerView()!
            container.addSubview(to.view)
        case .Out:
            to = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
            from = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        }
    }
}
