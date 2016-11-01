//
//  PopupDialogButton.swift
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

/// Represents the default button for the popup dialog
open class PopupDialogButton: UIButton {

    public typealias PopupDialogButtonAction = () -> Void

    // MARK: Public

    /// The font and size of the button title
    open dynamic var titleFont: UIFont? {
        get { return titleLabel?.font }
        set { titleLabel?.font = newValue }
    }
    
    /// The height of the button
    open dynamic var buttonHeight: Int
    
    /// The title color of the button
    open dynamic var titleColor: UIColor? {
        get { return self.titleColor(for: UIControlState()) }
        set { setTitleColor(newValue, for: UIControlState()) }
    }

    /// The background color of the button
    open dynamic var buttonColor: UIColor? {
        get { return backgroundColor }
        set { backgroundColor = newValue }
    }

    /// The separator color of this button
    open dynamic var separatorColor: UIColor? {
        get { return separator.backgroundColor }
        set {
            separator.backgroundColor = newValue
            leftSeparator.backgroundColor = newValue
        }
    }

    /// Default appearance of the button
    open var defaultTitleFont      = UIFont.systemFont(ofSize: 14)
    open var defaultTitleColor     = UIColor(red: 0.25, green: 0.53, blue: 0.91, alpha: 1)
    open var defaultButtonColor    = UIColor.clear
    open var defaultSeparatorColor = UIColor(white: 0.9, alpha: 1)

    /// Whether button should dismiss popup when tapped
    open var dismissOnTap = true

    /// The action called when the button is tapped
    open fileprivate(set) var buttonAction: PopupDialogButtonAction?

    // MARK: Private

    fileprivate lazy var separator: UIView = {
        let line = UIView(frame: .zero)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()

    fileprivate lazy var leftSeparator: UIView = {
        let line = UIView(frame: .zero)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.alpha = 0
        return line
    }()

    // MARK: Internal

    internal var needsLeftSeparator: Bool = false {
        didSet {
            leftSeparator.alpha = needsLeftSeparator ? 1.0 : 0.0
        }
    }

    // MARK: Initializers

    /*!
     Creates a button that can be added to the popup dialog

     - parameter title:         The button title
     - parameter dismisssOnTap: Whether a tap automatically dismisses the dialog
     - parameter action:        The action closure

     - returns: PopupDialogButton
     */
    public init(title: String,
                height: Int = 45,
                dismissOnTap: Bool = true, action: PopupDialogButtonAction?) {

        // Assign the button height
        buttonHeight = height
        
        // Assign the button action
        buttonAction = action

        super.init(frame: .zero)

        // Set the button title
        setTitle(title, for: UIControlState())

        self.dismissOnTap = dismissOnTap

        // Setup the views
        setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View setup

    open func setupView() {

        // Default appearance
        setTitleColor(defaultTitleColor, for: UIControlState())
        titleLabel?.font              = defaultTitleFont
        backgroundColor               = defaultButtonColor
        separator.backgroundColor     = defaultSeparatorColor
        leftSeparator.backgroundColor = defaultSeparatorColor

        // Add and layout views
        addSubview(separator)
        addSubview(leftSeparator)

        let views = ["separator": separator, "leftSeparator": leftSeparator, "button": self]
        let metrics = ["buttonHeight": buttonHeight]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[button(buttonHeight)]", options: [], metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[separator]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[separator(1)]", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[leftSeparator(1)]", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[leftSeparator]|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(constraints)
    }

    open override var isHighlighted: Bool {
        didSet {
            isHighlighted ? pv_fade(.out, 0.5) : pv_fade(.in, 1.0)
        }
    }
}
