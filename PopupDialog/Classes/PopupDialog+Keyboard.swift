//
//  PopupDialog+Keyboard.swift
//  Pods
//
//  Created by Martin Wildfeuer on 06.08.16.
//
//

import Foundation
import UIKit

/// This extension is designed to
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
