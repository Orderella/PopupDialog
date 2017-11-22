//
//  PopupDialogContainerView.swift
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

import Foundation
import UIKit

/// The main view of the popup dialog
final public class PopupDialogContainerView: UIView {

    // MARK: - Appearance

    /// The background color of the popup dialog
    override public dynamic var backgroundColor: UIColor? {
        get { return container.backgroundColor }
        set { container.backgroundColor = newValue }
    }

    /// The corner radius of the popup view
    @objc public dynamic var cornerRadius: Float {
        get { return Float(shadowContainer.layer.cornerRadius) }
        set {
            let radius = CGFloat(newValue)
            shadowContainer.layer.cornerRadius = radius
            container.layer.cornerRadius = radius
        }
    }

    /// Enable / disable shadow rendering
    @objc public dynamic var shadowEnabled: Bool {
        get { return shadowContainer.layer.shadowRadius > 0 }
        set { shadowContainer.layer.shadowRadius = newValue ? 5 : 0 }
    }

    /// The shadow color
    @objc public dynamic var shadowColor: UIColor? {
        get {
            guard let color = shadowContainer.layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set { shadowContainer.layer.shadowColor = newValue?.cgColor }
    }

    // MARK: - Views

    /// The shadow container is the basic view of the PopupDialog
    /// As it does not clip subviews, a shadow can be applied to it
    internal lazy var shadowContainer: UIView = {
        let shadowContainer = UIView(frame: .zero)
        shadowContainer.translatesAutoresizingMaskIntoConstraints = false
        shadowContainer.backgroundColor = UIColor.clear
        shadowContainer.layer.shadowColor = UIColor.black.cgColor
        shadowContainer.layer.shadowRadius = 5
        shadowContainer.layer.shadowOpacity = 0.4
        shadowContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowContainer.layer.cornerRadius = 4
        return shadowContainer
    }()

    /// The container view is a child of shadowContainer and contains
    /// all other views. It clips to bounds so cornerRadius can be set
    internal lazy var container: UIView = {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.white
        container.clipsToBounds = true
        container.layer.cornerRadius = 4
        return container
    }()

    // The container stack view for buttons
    internal lazy var buttonStackView: UIStackView = {
        let buttonStackView = UIStackView()
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 0
        return buttonStackView
    }()

    // The main stack view, containing all relevant views
    internal lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.buttonStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    // The preferred width for iPads
    fileprivate let preferredWidth: CGFloat

    // MARK: - Constraints

    /// The center constraint of the shadow container
    internal var centerYConstraint: NSLayoutConstraint?

    // MARK: - Initializers
    
    internal init(frame: CGRect, preferredWidth: CGFloat) {
        self.preferredWidth = preferredWidth
        super.init(frame: frame)
        setupViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View setup

    internal func setupViews() {

        // Add views
        addSubview(shadowContainer)
        shadowContainer.addSubview(container)
        container.addSubview(stackView)

        // Layout views
        let views = ["shadowContainer": shadowContainer, "container": container, "stackView": stackView]
        var constraints = [NSLayoutConstraint]()

        // Shadow container constraints
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            let metrics = ["preferredWidth": preferredWidth]
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=40)-[shadowContainer(==preferredWidth@900)]-(>=40)-|", options: [], metrics: metrics, views: views)
        } else {
            constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=10,==20@900)-[shadowContainer(<=340,>=300)]-(>=10,==20@900)-|", options: [], metrics: nil, views: views)
        }
        constraints += [NSLayoutConstraint(item: shadowContainer, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)]
        centerYConstraint = NSLayoutConstraint(item: shadowContainer, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        
        if let centerYConstraint = centerYConstraint {
            constraints.append(centerYConstraint)
        }
        
        // Container constraints
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[container]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[container]|", options: [], metrics: nil, views: views)

        // Main stack view constraints
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: [], metrics: nil, views: views)

        // Activate constraints
        NSLayoutConstraint.activate(constraints)
    }
}
