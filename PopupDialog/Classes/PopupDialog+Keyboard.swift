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
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged),
                                                         name: UIDevice.orientationDidChangeNotification,
                                                         object: nil)

        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(keyboardWillShow),
                                                         name: UIResponder.keyboardWillShowNotification,
                                                         object: nil)

        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(keyboardWillHide),
                                                         name: UIResponder.keyboardWillHideNotification,
                                                         object: nil)

        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(keyboardWillChangeFrame),
                                                         name: UIResponder.keyboardWillChangeFrameNotification,
                                                         object: nil)
    }

    /*! Remove observers */
    func removeObservers() {
        NotificationCenter.default.removeObserver(self,
                                                            name: UIDevice.orientationDidChangeNotification,
                                                            object: nil)

        NotificationCenter.default.removeObserver(self,
                                                            name: UIResponder.keyboardWillShowNotification,
                                                            object: nil)

        NotificationCenter.default.removeObserver(self,
                                                            name: UIResponder.keyboardWillHideNotification,
                                                            object: nil)

        NotificationCenter.default.removeObserver(self,
                                                            name: UIResponder.keyboardWillChangeFrameNotification,
                                                            object: nil)
    }

    // MARK: - Actions

    /*!
     Keyboard will show notification listener
     - parameter notification: NSNotification
     */
    @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        guard isTopAndVisible else { return }
        keyboardShown = true
        centerPopup()
    }

    /*!
     Keyboard will hide notification listener
     - parameter notification: NSNotification
     */
    @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        guard isTopAndVisible else { return }
        keyboardShown = false
        centerPopup()
    }

    /*!
     Keyboard will change frame notification listener
     - parameter notification: NSNotification
     */
    @objc fileprivate func keyboardWillChangeFrame(_ notification: Notification) {
        guard let keyboardRect = (notification as NSNotification).userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        keyboardHeight = keyboardRect.cgRectValue.height
    }

    /*!
     Listen to orientation changes
     - parameter notification: NSNotification
     */
    @objc fileprivate func orientationChanged(_ notification: Notification) {
        if keyboardShown { centerPopup() }
    }

    fileprivate func centerPopup() {

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
