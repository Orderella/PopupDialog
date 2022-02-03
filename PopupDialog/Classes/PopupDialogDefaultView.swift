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

/// Image layout of the popup dialog.
@objc public enum PopupDialogImageLayout: Int {
    /// Image fills the width of the dialog.
    case fill
    /// Image with intrinsic size and centered horizontally in the dialog.
    case center
}

/// The main view of the popup dialog
final public class PopupDialogDefaultView: UIView {

    // MARK: - Appearance

    /// The font and size of the title label
    @objc public dynamic var titleFont: UIFont {
        get { return titleLabel.font }
        set { titleLabel.font = newValue }
    }

    /// The color of the title label
    @objc public dynamic var titleColor: UIColor? {
        get { return titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }

    /// The text alignment of the title label
    @objc public dynamic var titleTextAlignment: NSTextAlignment {
        get { return titleLabel.textAlignment }
        set { titleLabel.textAlignment = newValue }
    }

    /// The font and size of the body label
    @objc public dynamic var messageFont: UIFont {
        get { return messageLabel.font }
        set { messageLabel.font = newValue }
    }

    /// The color of the message label
    @objc public dynamic var messageColor: UIColor? {
        get { return messageLabel.textColor }
        set { messageLabel.textColor = newValue}
    }

    /// The text alignment of the message label
    @objc public dynamic var messageTextAlignment: NSTextAlignment {
        get { return messageLabel.textAlignment }
        set { messageLabel.textAlignment = newValue }
    }

    // MARK: - Views

    /// The view that will contain the image, if set
    internal lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    /// The title label of the dialog
    internal lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(white: 0.4, alpha: 1)
        titleLabel.font = .boldSystemFont(ofSize: 14)
        return titleLabel
    }()

    /// The message label of the dialog
    internal lazy var messageLabel: UILabel = {
        let messageLabel = UILabel(frame: .zero)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = UIColor(white: 0.6, alpha: 1)
        messageLabel.font = .systemFont(ofSize: 14)
        return messageLabel
    }()
    
    /// The height constraint of the image view, 0 by default
    internal var imageHeightConstraint: NSLayoutConstraint?

    internal var imageLayout: PopupDialogImageLayout = .fill

    private var layoutConstraints = [NSLayoutConstraint]()

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

        // Self setup
        translatesAutoresizingMaskIntoConstraints = false

        // Add views
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(messageLabel)

    }

    public override func updateConstraints() {
        super.updateConstraints()

        if layoutConstraints.count > 0 {
            removeConstraints(layoutConstraints)
            layoutConstraints.removeAll()
        }

        let views = ["imageView": imageView, "titleLabel": titleLabel, "messageLabel": messageLabel] as [String: Any]

        switch imageLayout {
            case .fill:
                layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: [], metrics: nil, views: views)
                layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]", options: [], metrics: nil, views: views)
            case .center:
                layoutConstraints.append(contentsOf: [
                    imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
                    imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    imageView.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: self.leadingAnchor, multiplier: 1.0),
                    self.trailingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: imageView.trailingAnchor, multiplier: 1.0),
                ])
            @unknown default:
                layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: [], metrics: nil, views: views)
                layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]", options: [], metrics: nil, views: views)
        }
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(==20@900)-[titleLabel]-(==20@900)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(==20@900)-[messageLabel]-(==20@900)-|", options: [], metrics: nil, views: views)

        // Setup top constraints depending on whether we have a title or not
        if let titleText = titleLabel.text, !titleText.isEmpty {
            layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[imageView]-(==30@900)-[titleLabel]", options: [], metrics: nil, views: views)
        } else {
            layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[imageView]-(==30@900)-[messageLabel]", options: [], metrics: nil, views: views)
        }

        // Setup bottom constraints depending on whether we have a message text or not
        if let messageText = messageLabel.text, !messageText.isEmpty {
            layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[titleLabel]-(==8@900)-[messageLabel]-(==30@900)-|", options: [], metrics: nil, views: views)
        } else {
            layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[titleLabel]-(==30@900)-|", options: [], metrics: nil, views: views)
        }

        // ImageView height constraint
        imageHeightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 0, constant: 0)

        if let imageHeightConstraint = imageHeightConstraint {
            layoutConstraints.append(imageHeightConstraint)
        }

        // Activate constraints
        NSLayoutConstraint.activate(layoutConstraints)

    }
}
