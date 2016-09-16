//
//  PopupDialogOverlayView.swift
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

/// The (blurred) overlay view below the popup dialog
final public class PopupDialogOverlayView: UIView {

    // MARK: - Appearance

    ///  The blur radius of the overlay view
    public dynamic var blurRadius: Float {
        get { return Float(blurView.blurRadius) }
        set { blurView.blurRadius = CGFloat(newValue) }
    }

    /// Turns the blur of the overlay view on or off
    public dynamic var blurEnabled: Bool {
        get { return blurView.isBlurEnabled }
        set {
            blurView.isBlurEnabled = newValue
            blurView.alpha = newValue ? 1 : 0
        }
    }

    /// Whether the blur view should allow for
    /// dynamic rendering of the background
    public dynamic var liveBlur: Bool {
        get { return blurView.isDynamic }
        set { return blurView.isDynamic = newValue }
    }

    /// The background color of the overlay view
    public dynamic var color: UIColor? {
        get { return overlay.backgroundColor }
        set { overlay.backgroundColor = newValue }
    }

    /// The opacity of the overay view
    public dynamic var opacity: Float {
        get { return Float(overlay.alpha) }
        set { overlay.alpha = CGFloat(newValue) }
    }

    // MARK: - Views

    internal lazy var blurView: FXBlurView = {
        let blurView = FXBlurView(frame: .zero)
        blurView.blurRadius = 8
        blurView.isDynamic = false
        blurView.tintColor = UIColor.clear
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return blurView
    }()

    internal lazy var overlay: UIView = {
        let overlay = UIView(frame: .zero)
        overlay.backgroundColor = UIColor.black
        overlay.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        overlay.alpha = 0.7
        return overlay
    }()

    // MARK: - Inititalizers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View setup

    fileprivate func setupView() {

        // Self appearance
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.backgroundColor = UIColor.clear
        self.alpha = 0

        // Add subviews
        addSubview(blurView)
        addSubview(overlay)
    }

}
