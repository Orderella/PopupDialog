//
//  PopupDialogTransitionAnimations.swift
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

// MARK: Presentation animation

final internal class TransitionPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.18
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let to = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! PopupDialog
        let from = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let containerView = transitionContext.containerView()

        to.view.bounds.origin = CGPoint(x: 0, y: -from.view.bounds.size.height)
        containerView!.addSubview(to.view)

        UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.CurveEaseOut], animations: {
            to.view.bounds = from.view.bounds
        }) { (completed) in
            transitionContext.completeTransition(completed)
        }
    }
}

// MARK: Dismiss animation

final internal class TransitionDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.2
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let from = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let animationDuration = self .transitionDuration(transitionContext)

        UIView.animateWithDuration(animationDuration, delay: 0.0, options: [.CurveEaseIn], animations: {
            from.view.bounds.origin = CGPoint(x: 0, y: -from.view.bounds.size.height)
            from.view.alpha = 0.0
        }) { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}
