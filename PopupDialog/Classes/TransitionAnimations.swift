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

/*!
 Presentation transition styles for the popup dialog

 - BounceUp:   Dialog bounces in from bottom and is dismissed to bottom
 - BounceDown: Dialog bounces in from top and is dismissed to top
 - ZoomIn:     Dialog zooms in and is dismissed by zooming out
 - FadeIn:     Dialog fades in and is dismissed by fading out
 */
@objc public enum PopupDialogTransitionStyle: Int {
    case bounceUp
    case bounceDown
    case zoomIn
    case fadeIn
}

/// Dialog bounces in from bottom and is dismissed to bottom
final internal class BounceUpTransition: TransitionAnimator {

    init(direction: AnimationDirection) {
        super.init(inDuration: 0.22, outDuration: 0.2, direction: direction)
    }

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext)

        switch direction {
        case .in:
            to.view.bounds.origin = CGPoint(x: 0, y: -from.view.bounds.size.height)
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseOut], animations: { [weak self] in
                guard let self = self else { return }
                self.to.view.bounds = self.from.view.bounds
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        case .out:
            UIView.animate(withDuration: outDuration, delay: 0.0, options: [.curveEaseIn], animations: { [weak self] in
                guard let self = self else { return }
                self.from.view.bounds.origin = CGPoint(x: 0, y: -self.from.view.bounds.size.height)
                self.from.view.alpha = 0.0
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}


/// Dialog bounces in from top and is dismissed to top
final internal class BounceDownTransition: TransitionAnimator {

    init(direction: AnimationDirection) {
        super.init(inDuration: 0.22, outDuration: 0.2, direction: direction)
    }

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext)

        switch direction {
        case .in:
            to.view.bounds.origin = CGPoint(x: 0, y: from.view.bounds.size.height)
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseOut], animations: { [weak self] in
                guard let self = self else { return }
                self.to.view.bounds = self.from.view.bounds
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        case .out:
            UIView.animate(withDuration: outDuration, delay: 0.0, options: [.curveEaseIn], animations: { [weak self] in
                guard let self = self else { return }
                self.from.view.bounds.origin = CGPoint(x: 0, y: self.from.view.bounds.size.height)
                self.from.view.alpha = 0.0
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}

/// Dialog zooms in and is dismissed by zooming out
final internal class ZoomTransition: TransitionAnimator {

    init(direction: AnimationDirection) {
        super.init(inDuration: 0.22, outDuration: 0.2, direction: direction)
    }

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext)

        switch direction {
        case .in:
            to.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseOut], animations: { [weak self] in
                guard let self = self else { return }
                self.to.view.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        case .out:
            UIView.animate(withDuration: outDuration, delay: 0.0, options: [.curveEaseIn], animations: { [weak self] in
                guard let self = self else { return }
                self.from.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.from.view.alpha = 0.0
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}

/// Dialog fades in and is dismissed by fading out
final internal class FadeTransition: TransitionAnimator {

    init(direction: AnimationDirection) {
        super.init(inDuration: 0.22, outDuration: 0.2, direction: direction)
    }

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext)

        switch direction {
        case .in:
            to.view.alpha = 0
            UIView.animate(withDuration: 0.6, delay: 0.0, options: [.curveEaseOut],
            animations: { [weak self] in
                guard let self = self else { return }
                self.to.view.alpha = 1
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        case .out:
            UIView.animate(withDuration: outDuration, delay: 0.0, options: [.curveEaseIn], animations: { [weak self] in
                guard let self = self else { return }
                self.from.view.alpha = 0.0
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}

/// Used for the always drop out animation with pan gesture dismissal
final internal class DismissInteractiveTransition: TransitionAnimator {

    init() {
        super.init(inDuration: 0.22, outDuration: 0.32, direction: .out)
    }

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext)
        UIView.animate(withDuration: outDuration, delay: 0.0, options: [.beginFromCurrentState], animations: { [weak self] in
            guard let self = self else { return }
            self.from.view.bounds.origin = CGPoint(x: 0, y: -self.from.view.bounds.size.height)
            self.from.view.alpha = 0.0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
