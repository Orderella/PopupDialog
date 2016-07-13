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
final public class PopupDialogDefaultView: UIView {

    // MARK: - Appearance

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

    // MARK: - Views

    /// The view that will contain the image, if set
    internal lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()

    /// The title label of the dialog
    internal lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor(white: 0.4, alpha: 1)
        titleLabel.font = UIFont.boldSystemFontOfSize(14)
        return titleLabel
    }()

    /// The message label of the dialog
    internal lazy var messageLabel: UILabel = {
        let messageLabel = UILabel(frame: .zero)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .Center
        messageLabel.textColor = UIColor(white: 0.6, alpha: 1)
        messageLabel.font = UIFont.systemFontOfSize(14)
        return messageLabel
    }()

    // The text view containing the labels
    internal lazy var textStackView: UIStackView = {
        let textStackView = UIStackView(arrangedSubviews: [self.titleLabel, self.messageLabel])
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.axis = .Vertical
        textStackView.spacing = 12
        return textStackView
    }()

    /// A horizontal stack view, adding left/right padding
    /// to the textStackView
    internal lazy var spacerStackView: UIStackView = {
        // This is a workaround for adding left and right padding to
        // the textStackView. I tried setting constraints / insets / anchors
        // All these resulted in unsatisfyable constraints
        let leftSpacer = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        let rightSpacer = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        let spacerStackView = UIStackView(arrangedSubviews: [leftSpacer, self.textStackView, rightSpacer])
        spacerStackView.translatesAutoresizingMaskIntoConstraints = false
        spacerStackView.axis = .Horizontal
        spacerStackView.spacing = 12
        spacerStackView.distribution = .FillProportionally
        return spacerStackView
    }()

    // The main stack view, containing all relevant views
    internal lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.imageView, self.spacerStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .Vertical
        stackView.spacing = 30
        return stackView
    }()

    // MARK: - Constraints

    /// The height constraint of the image view, 0 by default
    internal var imageHeightConstraint: NSLayoutConstraint?

    // MARK: - Initializers

    internal override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View setup

    internal func setupViews() {
        // Add views
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        // Layout views
        let views = ["stackView": stackView, "imageView": imageView]
        var constraints = [NSLayoutConstraint]()

        // Main stack view constraints
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[stackView]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[stackView]-30-|", options: [], metrics: nil, views: views)

        // ImageView constraints
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[imageView]|", options: [], metrics: nil, views: views)
        imageHeightConstraint = NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 0, constant: 0)
        constraints.append(imageHeightConstraint!)

        // Activate constraints
        NSLayoutConstraint.activateConstraints(constraints)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        imageHeightConstraint?.constant = imageView.pv_heightForImageView()
    }
}
