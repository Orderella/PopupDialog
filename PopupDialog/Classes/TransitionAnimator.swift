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

    var to: UIViewController! // swiftlint:disable:this identifier_name
    var from: UIViewController!
    let inDuration: TimeInterval
    let outDuration: TimeInterval
    let direction: AnimationDirection

    init(inDuration: TimeInterval, outDuration: TimeInterval, direction: AnimationDirection) {
        self.inDuration = inDuration
        self.outDuration = outDuration
        self.direction = direction
        super.init()
    }

    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return direction == .in ? inDuration : outDuration
    }

    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch direction {
        case .in:
            guard let to = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
                let from = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { return }
            
            self.to = to
            self.from = from

            let container = transitionContext.containerView
            container.addSubview(to.view)
        case .out:
            guard let to = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
                let from = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { return }
            
            self.to = to
            self.from = from
        }
    }
}
