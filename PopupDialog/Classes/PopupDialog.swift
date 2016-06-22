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

    /// Button alignment on given axis
    private let buttonAlignment: UILayoutConstraintAxis

    /// The custom transition presentation manager
    private lazy var presentationManager: PopupDialogPresentationManager = { PopupDialogPresentationManager() }()

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
    public init(title: String?, message: String?, image: UIImage? = nil, buttonAlignment: UILayoutConstraintAxis = .Vertical) {
        self.buttonAlignment = buttonAlignment
        super.init(nibName: nil, bundle: nil)

        // Define presentation styles
        transitioningDelegate = presentationManager
        modalPresentationStyle = .Custom

        // Assign label text
        popupView.titleLabel.text = title
        popupView.messageLabel.text = message

        // Assign image and set height accordingly
        view.layoutIfNeeded()
        popupView.imageView.image = image
        popupView.imageHeightConstraint?.constant = popupView.imageView.pv_heightForImageView()
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
    
    // If touch occurs outside of shadowContainer dismiss view controller
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let firstTouch = touches.first {
            let point = firstTouch.locationInView(self.view)
            if CGRectContainsPoint(popupView.shadowContainer.frame, point) == false {
                dismissViewControllerAnimated(true, completion: nil)
            }
        }
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
