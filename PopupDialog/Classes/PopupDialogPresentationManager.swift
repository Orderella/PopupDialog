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

final internal class PopupDialogPresentationManager: NSObject, UIViewControllerTransitioningDelegate {

    var transitionStyle: PopupDialogTransitionStyle

    init(transitionStyle: PopupDialogTransitionStyle) {
        self.transitionStyle = transitionStyle
        super.init()
    }

    func presentationController(forPresentedViewController presented: UIViewController, presenting: UIViewController?, sourceViewController source: UIViewController) -> UIPresentationController? {
        let presentationController = PopupDialogPresentationController(presentedViewController: presented, presenting: source)
        return presentationController
    }

    func animationController(forPresentedController presented: UIViewController, presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        var transition: TransitionAnimator
        switch transitionStyle {
        case .bounceUp:
            transition = BounceUpTransition(direction: .in)
        case .bounceDown:
            transition = BounceDownTransition(direction: .in)
        case .zoomIn:
            transition = ZoomTransition(direction: .in)
        case .fadeIn:
            transition = FadeTransition(direction: .in)
        }

        return transition
    }

    func animationController(forDismissedController dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        var transition: TransitionAnimator
        switch transitionStyle {
        case .bounceUp:
            transition = BounceUpTransition(direction: .out)
        case .bounceDown:
            transition = BounceDownTransition(direction: .out)
        case .zoomIn:
            transition = ZoomTransition(direction: .out)
        case .fadeIn:
            transition = FadeTransition(direction: .out)
        }

        return transition
    }
}
