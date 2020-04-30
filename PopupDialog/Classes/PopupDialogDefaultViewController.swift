//
//  PopupDialogDefaultViewController.swift
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

import UIKit

final public class PopupDialogDefaultViewController: UIViewController {

    public var standardView: PopupDialogDefaultView {
       return view as! PopupDialogDefaultView // swiftlint:disable:this force_cast
    }

    override public func loadView() {
        super.loadView()
        view = PopupDialogDefaultView(frame: .zero)
    }
}

public extension PopupDialogDefaultViewController {

    // MARK: - Setter / Getter

    // MARK: Content

    /// The dialog image
    var image: UIImage? {
        get { return standardView.imageView.image }
        set {
            standardView.imageView.image = newValue
            standardView.imageHeightConstraint?.constant = standardView.imageView.pv_heightForImageView()
        }
    }

    /// The title text of the dialog
    var titleText: String? {
        get { return standardView.titleLabel.text }
        set {
            standardView.titleLabel.text = newValue
            standardView.pv_layoutIfNeededAnimated()
        }
    }

    /// The message text of the dialog
    var messageText: String? {
        get { return standardView.messageLabel.text }
        set {
            standardView.messageLabel.text = newValue
            standardView.pv_layoutIfNeededAnimated()
        }
    }

    // MARK: Appearance

    /// The font and size of the title label
    @objc dynamic var titleFont: UIFont {
        get { return standardView.titleFont }
        set {
            standardView.titleFont = newValue
            standardView.pv_layoutIfNeededAnimated()
        }
    }

    /// The color of the title label
    @objc dynamic var titleColor: UIColor? {
        get { return standardView.titleLabel.textColor }
        set {
            standardView.titleColor = newValue
            standardView.pv_layoutIfNeededAnimated()
        }
    }

    /// The text alignment of the title label
    @objc dynamic var titleTextAlignment: NSTextAlignment {
        get { return standardView.titleTextAlignment }
        set {
            standardView.titleTextAlignment = newValue
            standardView.pv_layoutIfNeededAnimated()
        }
    }

    /// The font and size of the body label
    @objc dynamic var messageFont: UIFont {
        get { return standardView.messageFont}
        set {
            standardView.messageFont = newValue
            standardView.pv_layoutIfNeededAnimated()
        }
    }

    /// The color of the message label
    @objc dynamic var messageColor: UIColor? {
        get { return standardView.messageColor }
        set {
            standardView.messageColor = newValue
            standardView.pv_layoutIfNeededAnimated()
        }
    }

    /// The text alignment of the message label
    @objc dynamic var messageTextAlignment: NSTextAlignment {
        get { return standardView.messageTextAlignment }
        set {
            standardView.messageTextAlignment = newValue
            standardView.pv_layoutIfNeededAnimated()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        standardView.imageHeightConstraint?.constant = standardView.imageView.pv_heightForImageView()
    }
}
