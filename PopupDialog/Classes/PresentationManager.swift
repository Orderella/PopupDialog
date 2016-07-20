//
//  PopupDialogPresentationManager.swift
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

final internal class PresentationManager: NSObject, UIViewControllerTransitioningDelegate {

    var transitionStyle: PopupDialogTransitionStyle
    var interactor: InteractiveTransition

    init(transitionStyle: PopupDialogTransitionStyle, interactor: InteractiveTransition) {
        self.transitionStyle = transitionStyle
        self.interactor = interactor
        super.init()
    }

    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let presentationController = PresentationController(presentedViewController: presented, presentingViewController: source)
        return presentationController
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        var transition: TransitionAnimator
        switch transitionStyle {
        case .BounceUp:
            transition = BounceUpTransition(direction: .In)
        case .BounceDown:
            transition = BounceDownTransition(direction: .In)
        case .ZoomIn:
            transition = ZoomTransition(direction: .In)
        case .FadeIn:
            transition = FadeTransition(direction: .In)
        }

        return transition
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if interactor.hasStarted || interactor.shouldFinish {
            return DismissInteractiveTransition()
        }

        var transition: TransitionAnimator
        switch transitionStyle {
        case .BounceUp:
            transition = BounceUpTransition(direction: .Out)
        case .BounceDown:
            transition = BounceDownTransition(direction: .Out)
        case .ZoomIn:
            transition = ZoomTransition(direction: .Out)
        case .FadeIn:
            transition = FadeTransition(direction: .Out)
        }

        return transition
    }

    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
