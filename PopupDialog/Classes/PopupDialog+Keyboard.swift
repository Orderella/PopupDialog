//
//  PopupDialog+Keyboard.swift
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

/// This extension is designed to handle dialog positioning
/// if a keyboard is displayed while the popup is on top
internal extension PopupDialog {

    // MARK: - Keyboard & orientation observers

    /*! Add obserservers for UIKeyboard notifications */
    internal func addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(orientationChanged),
                                                         name: UIDeviceOrientationDidChangeNotification,
                                                         object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(keyboardWillShow),
                                                         name: UIKeyboardWillShowNotification,
                                                         object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(keyboardWillHide),
                                                         name: UIKeyboardWillHideNotification,
                                                         object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(keyboardWillChangeFrame),
                                                         name: UIKeyboardWillChangeFrameNotification,
                                                         object: nil)
    }

    /*! Remove observers */
    internal func removeObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UIDeviceOrientationDidChangeNotification,
                                                            object: nil)

        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UIKeyboardWillShowNotification,
                                                            object: nil)

        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UIKeyboardWillHideNotification,
                                                            object: nil)

        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: UIKeyboardWillChangeFrameNotification,
                                                            object: nil)
    }

    // MARK: - Actions

    /*!
     Keyboard will show notification listener
     - parameter notification: NSNotification
     */
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard isTopAndVisible else { return }
        keyboardShown = true
        centerPopup()
    }

    /*!
     Keyboard will hide notification listener
     - parameter notification: NSNotification
     */
    @objc private func keyboardWillHide(notification: NSNotification) {
        guard isTopAndVisible else { return }
        keyboardShown = false
        centerPopup()
    }

    /*!
     Keyboard will change frame notification listener
     - parameter notification: NSNotification
     */
    @objc private func keyboardWillChangeFrame(notification: NSNotification) {
        guard let keyboardRect = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        keyboardHeight = keyboardRect.CGRectValue().height
    }

    /*!
     Listen to orientation changes
     - parameter notification: NSNotification
     */
    @objc private func orientationChanged(notification: NSNotification) {
        if keyboardShown { centerPopup() }
    }

    private func centerPopup() {

        // Make sure keyboard should reposition on keayboard notifications
        guard keyboardShiftsView else { return }

        // Make sure a valid keyboard height is available
        guard let keyboardHeight = keyboardHeight else { return }

        // Calculate new center of shadow background
        let popupCenter =  keyboardShown ? keyboardHeight / -2 : 0

        // Reposition and animate
        popupContainerView.centerYConstraint?.constant = popupCenter
        popupContainerView.pv_layoutIfNeededAnimated()
    }
}
