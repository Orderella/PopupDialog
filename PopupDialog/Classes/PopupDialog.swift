//
//  PopupDialog.swift
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

/// Creates a Popup dialog similar to UIAlertController
final public class PopupDialog: UIViewController {

    // MARK: Private

    /// The custom transition presentation manager
    private let presentationManager: PopupDialogPresentationManager

    /// Returns the controllers view
    private var popupView: PopupDialogView {
        return view as! PopupDialogView
    }

    /// The set of buttons
    private var buttons = [PopupDialogButton]()

    // MARK: Initializers

    /*!
     Creates a custom Popup Dialog view that can be
     presented just like a view controller

     - parameter title:   The dialog title
     - parameter message: The dialog body
     - parameter image:   The image displayed on top

     - returns: Popup dialog view
     */
    public init(title: String?,
                message: String?,
                image: UIImage? = nil,
                transitionStyle: PopupDialogTransitionStyle = .BounceUp,
                buttonAlignment: UILayoutConstraintAxis = .Vertical) {

        presentationManager = PopupDialogPresentationManager(transitionStyle: transitionStyle)
        super.init(nibName: nil, bundle: nil)

        // Define presentation styles
        transitioningDelegate = presentationManager
        modalPresentationStyle = .Custom

        // Assign values
        titleText = title
        messageText = message
        self.image = image
        self.buttonAlignment = buttonAlignment
    }

    // Init with coder not implemented
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: View lifecycle

extension PopupDialog {

    /// Replaces controller view with popup view
    public override func loadView() {
        view = PopupDialogView(frame: UIScreen.mainScreen().bounds)
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // FIXME: Make sure this is called only once
        appendButtons()
    }
}

// MARK: View proxies

extension PopupDialog {

    /// The dialog image
    public var image: UIImage? {
        get { return popupView.imageView.image }
        set {
            popupView.imageView.image = newValue
            popupView.imageHeightConstraint?.constant = popupView.imageView.pv_heightForImageView()
            popupView.pv_layoutIfNeededAnimated()
        }
    }

    /// The title text of the dialog
    public var titleText: String? {
        get { return popupView.titleLabel.text }
        set {
            popupView.titleLabel.text = newValue
            popupView.pv_layoutIfNeededAnimated()
        }
    }

    /// The message text of the dialog
    public var messageText: String? {
        get { return popupView.messageLabel.text }
        set {
            popupView.messageLabel.text = newValue
            popupView.pv_layoutIfNeededAnimated()
        }
    }

    /// The button alignment of the alert dialog
    public var buttonAlignment: UILayoutConstraintAxis {
        get { return popupView.buttonStackView.axis }
        set {
            popupView.buttonStackView.axis = newValue
            popupView.pv_layoutIfNeededAnimated()
        }
    }

    /// The transition style
    public var transitionStyle: PopupDialogTransitionStyle {
        get { return presentationManager.transitionStyle }
        set { presentationManager.transitionStyle = newValue }
    }
}

// MARK: Button actions

extension PopupDialog {

    /*!
     Appends the buttons added to the popup dialog
     to the placeholder stack view
     */
    private func appendButtons() {

        // Configure the button stack view
        popupView.buttonStackView.axis = buttonAlignment

        // Add action to buttons
        for (index, button) in buttons.enumerate() {
            button.needsLeftSeparator = buttonAlignment == .Horizontal && index > 0
            popupView.buttonStackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(buttonTapped(_:)), forControlEvents: .TouchUpInside)
        }
    }

    /*!
     Adds a single PopupDialogButton to the Popup dialog
     - parameter button: A PopupDialogButton instance
     */
    public func addButton(button: PopupDialogButton) {
        buttons.append(button)
    }

    /*!
     Adds an array of PopupDialogButtons to the Popup dialog
     - parameter buttons: A list of PopupDialogButton instances
     */
    public func addButtons(buttons: [PopupDialogButton]) {
        self.buttons += buttons
    }

    /// Calls the action closure of the button instance tapped
    @objc private func buttonTapped(button: PopupDialogButton) {
        button.buttonAction?()
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*!
     Simulates a button tap for the given index
     Makes testing a breeze
     - parameter index: The index of the button to tap
     */
    public func tapButtonWithIndex(index: Int) {
        let button = buttons[index]
        button.buttonAction?()
        dismissViewControllerAnimated(true, completion: nil)
    }

}
