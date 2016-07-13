//
//  PopupDialogDefaultViewController.swift
//  Pods
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

final class PopupDialogDefaultViewController: UIViewController {

    public var standardView: PopupDialogDefaultView {
       return view as! PopupDialogDefaultView
    }

    override func loadView() {
        super.loadView()
        view = PopupDialogDefaultView(frame: .zero)
    }
}

extension PopupDialogDefaultViewController {

    // MARK: - Setter / Getter

    /// The dialog image
    public var image: UIImage? {
        get { return standardView.imageView.image }
        set {
            standardView.imageView.image = newValue
            standardView.pv_layoutIfNeededAnimated()
        }
    }

    /// The title text of the dialog
    public var titleText: String? {
        get { return standardView.titleLabel.text }
        set {
            standardView.titleLabel.text = newValue
            standardView.pv_layoutIfNeededAnimated()
        }
    }

    /// The message text of the dialog
    public var messageText: String? {
        get { return standardView.messageLabel.text }
        set {
            standardView.messageLabel.text = newValue
            standardView.pv_layoutIfNeededAnimated()
        }
    }
}
