//
//  PopupDialogView.swift
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

/// The main view of the popup dialog
final public class PopupDialogView: UIView {

    // MARK: Appearance

    /// The background color of the popup dialog
    override public dynamic var backgroundColor: UIColor? {
        get { return container.backgroundColor }
        set { container.backgroundColor = newValue }
    }

    /// The font and size of the title label
    public dynamic var titleFont: UIFont {
        get { return titleLabel.font }
        set { titleLabel.font = newValue }
    }

    /// The color of the title label
    public dynamic var titleColor: UIColor? {
        get { return titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }

    /// The text alignment of the title label
    public dynamic var titleTextAlignment: NSTextAlignment {
        get { return titleLabel.textAlignment }
        set { titleLabel.textAlignment = newValue }
    }

    /// The font and size of the body label
    public dynamic var messageFont: UIFont {
        get { return messageLabel.font }
        set { messageLabel.font = newValue }
    }

    /// The color of the message label
    public dynamic var messageColor: UIColor? {
        get { return messageLabel.textColor }
        set { messageLabel.textColor = newValue}
    }

    /// The text alignment of the message label
    public dynamic var messageTextAlignment: NSTextAlignment {
        get { return messageLabel.textAlignment }
        set { messageLabel.textAlignment = newValue }
    }

    /// The corner radius of the popup view
    public dynamic var cornerRadius: Float {
        get { return Float(shadowContainer.layer.cornerRadius) }
        set {
            let radius = CGFloat(newValue)
            shadowContainer.layer.cornerRadius = radius
            container.layer.cornerRadius = radius
        }
    }

    // MARK: Views
    internal let shadowContainer: UIView
    internal let container: UIView
    internal let stackView: UIStackView
    internal let buttonStackView: UIStackView
    internal let imageView: UIImageView
    internal let titleLabel: UILabel
    internal let messageLabel: UILabel

    /// The height constraint of the image view, 0 by default
    internal var imageHeightConstraint: NSLayoutConstraint?

    // MARK: Initializers

    internal override init(frame: CGRect) {

        // Create views
        shadowContainer = UIView(frame: .zero)
        shadowContainer.translatesAutoresizingMaskIntoConstraints = false
        shadowContainer.backgroundColor = UIColor.clearColor()
        shadowContainer.layer.shadowColor = UIColor.blackColor().CGColor
        shadowContainer.layer.shadowRadius = 5
        shadowContainer.layer.shadowOpacity = 0.4
        shadowContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowContainer.layer.cornerRadius = 4

        container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.whiteColor()
        container.clipsToBounds = true
        container.layer.cornerRadius = 4

        imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.redColor()

        titleLabel = UILabel(frame: .zero)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor(white: 0.4, alpha: 1)
        titleLabel.font = UIFont.boldSystemFontOfSize(14)

        messageLabel = UILabel(frame: .zero)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .Center
        messageLabel.textColor = UIColor(white: 0.6, alpha: 1)
        messageLabel.font = UIFont.systemFontOfSize(14)

        let textStackView = UIStackView(arrangedSubviews: [titleLabel, messageLabel])
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.axis = .Vertical
        textStackView.spacing = 12

        // This is a workaround for adding left and right padding to
        // the textStackView. I tried setting constraints / insets / anchors
        // All these resulted in unsatisfyable constraints
        let leftSpacer = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        let rightSpacer = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        let spacerStackView = UIStackView(arrangedSubviews: [leftSpacer, textStackView, rightSpacer])
        spacerStackView.translatesAutoresizingMaskIntoConstraints = false
        spacerStackView.axis = .Horizontal
        spacerStackView.spacing = 12
        spacerStackView.distribution = .FillProportionally

        buttonStackView = UIStackView()
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.distribution = .FillEqually
        buttonStackView.spacing = 0

        stackView = UIStackView(arrangedSubviews: [imageView, spacerStackView, buttonStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .Vertical
        stackView.spacing = 25

        // Super init
        super.init(frame: frame)

        // Add views
        addSubview(shadowContainer)
        shadowContainer.addSubview(container)
        container.addSubview(stackView)

        // Layout views
        let views = ["shadowContainer": shadowContainer, "container": container, "stackView": stackView, "textStackView": textStackView, "imageView": imageView, "titleLabel": titleLabel, "messageLabel": messageLabel]
        var constraints = [NSLayoutConstraint]()

        // Shadow container constraints
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[shadowContainer]-20-|", options: [], metrics: nil, views: views)
        constraints.append(NSLayoutConstraint(item: shadowContainer, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))

        // Container constraints
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[container]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[container]|", options: [], metrics: nil, views: views)

        // Main stack view constraints
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[stackView]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[stackView]|", options: [], metrics: nil, views: views)

        // ImageView constraints
        imageHeightConstraint = NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 0, constant: 0)
        constraints.append(imageHeightConstraint!)

        // Activate all constraints
        NSLayoutConstraint.activateConstraints(constraints)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
