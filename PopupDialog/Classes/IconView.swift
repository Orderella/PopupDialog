//
//  IconView.swift
//
//  Copyright (c) 2016 Orderella Ltd. (http://orderella.co.uk)
//  Author - Bas van Kuijck (http://www.e-sites.nl)
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

public class IconView: UIView {

    // MARK: Private / Internal

    /// The container view that is masked and holds the imageView
    lazy private var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        self.addSubview(view)
        return view
    }()

    /// The actual imageView where the icon image will be put in
    lazy private var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        self.containerView.addSubview(iv)
        return iv
    }()

    weak internal var popupDialogContainerView: PopupDialogContainerView?

    // MARK: Public
    public enum Shape: Int {
        /// A circle (doh)
        case circle = 0

        // A square (4 even sides)
        case square = 4

        // A pentagon (5 even sides)
        case pentagon = 5

        // An hexagon (6 even sides)
        case hexagon = 6

        // An heptagon (7 even sides)
        case heptagon = 7

        // An octagon (8 even sides)
        case octagon = 8

        // An enneagon (9 even sides)
        case enneagon = 9

        // An decagon (10 even sides)
        case decagon = 10
    }

    /// Change the color of the image
    override public var tintColor: UIColor! {
        get { return imageView.tintColor }
        set { imageView.tintColor = newValue }
    }

    /// Change the image of the IconView
    public var image: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
    }

    /// Change the backgroundColor of the IconView
    override public var backgroundColor: UIColor? {
        get { return containerView.backgroundColor }
        set { containerView.backgroundColor = newValue }
    }

    /// What should the shape be of the container
    /// - see: IconView.Shape for possible values
    public var shape: Shape = .square {
        didSet {
            if _shouldUpdateImmediately {
                _update()
            }
        }
    }

    /// The width (and height) of this instance
    /// Aspect ratio is 1:1, so the height is equal to the width
    public var width: CGFloat = 110 {
        didSet {
            if _shouldUpdateImmediately {
                popupDialogContainerView?.stackViewTopConstraint.constant = width / 2.0
                _update()
            }
        }
    }

    /// How thick should the border surrounding the icon be?
    public var borderWidth: CGFloat = 5 {
        didSet {
            if _shouldUpdateImmediately {
                _update()
            }
        }
    }

    /// The color of the border
    public var borderColor: UIColor? {
        get { return super.backgroundColor }
        set { super.backgroundColor = newValue }
    }

    /// The radius of the corners of this instance
    public var cornerRadius: CGFloat = 5.0 {
        didSet {
            if _shouldUpdateImmediately {
                _update()
            }
        }
    }

    /// Image insets
    public var insets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            if _shouldUpdateImmediately {
                _update()
            }
        }
    }

    /// We use this variable so in the init function this class would not call _update 6 times in a row
    private var _shouldUpdateImmediately = false

    // MARK: - Initializers
    public convenience init(shape: Shape = .square,
                            width: CGFloat = 110,
                            borderWidth: CGFloat = 5,
                            cornerRadius: CGFloat = 5.0,
                            insets: UIEdgeInsets? = nil) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: width))
        self.borderColor = UIColor.white
        self.shape = shape
        self.width = width
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius

        let calcInsets = width / 6.0
        let insets = insets ?? UIEdgeInsets(top: calcInsets, left: calcInsets, bottom: calcInsets, right: calcInsets)
        self.insets = insets
        _update()
        _shouldUpdateImmediately = true
    }

    // MARK: - Draw the icon view
    private func _update() {
        self.frame = CGRect(x: 0, y: 0, width: width, height: width)
        let borderWidth2 = borderWidth * 2.0

        layer.masksToBounds = true
        switch shape {
        case .circle:
            layer.cornerRadius = width / 2.0
            containerView.layer.cornerRadius = (width - borderWidth2) / 2.0

        case .square:
            layer.cornerRadius = cornerRadius
            containerView.layer.cornerRadius = cornerRadius / (width / (width - borderWidth2))

        default:
            let sides = shape.rawValue

            layer.cornerRadius = 0
            var maskLayer = CAShapeLayer()
            var rect = CGRect(x: 0, y: 0, width: width, height: width)
            maskLayer.path = _roundedPolygonPathWithRect(rect, sides: sides, cornerRadius: Float(cornerRadius)).cgPath
            layer.mask = maskLayer

            maskLayer = CAShapeLayer()
            rect = CGRect(x: borderWidth, y: borderWidth, width: width - borderWidth2, height: width - borderWidth2)
            maskLayer.path = _roundedPolygonPathWithRect(rect, sides: sides, cornerRadius: Float(cornerRadius)).cgPath
            containerView.layer.mask = maskLayer
        }

        containerView.frame = CGRect(x: borderWidth,
                                     y: borderWidth,
                                     width: width - borderWidth2,
                                     height: width - borderWidth2)

        imageView.frame = CGRect(x: insets.left,
                                 y: insets.top,
                                 width: width - (insets.left + insets.right + borderWidth2),
                                 height: width - (insets.top + insets.bottom + borderWidth2))
    }
}

extension IconView {
    // MARK: Helper functions

    /*!
     Creates a path with a predefined set of sides and a corner radius

     - parameter square:       CGRect Where should the shape be drawn in
     - parameter sides:        Int The number of sides the shape should have
     - parameter cornerRadius: Float the radius of the corner

     - returns: UIBezierpath
    */
    private func _roundedPolygonPathWithRect(_ square: CGRect, sides: Int, cornerRadius: Float) -> UIBezierPath {
        let path = UIBezierPath()

        let theta = (2.0 * Float.pi) / Float(sides)
        let offset = cornerRadius * tanf(theta / 2.0)
        let squareWidth = Float(min(square.size.width, square.size.height))

        var length = squareWidth

        if sides % 4 != 0 {
            length = length * cosf(theta / 2.0) + offset / 2.0
        }

        let sideLength = length * tanf(theta / 2.0)

        var point = CGPoint(
            x: CGFloat((squareWidth / 2.0) + (sideLength / 2.0) - offset),
            y: CGFloat(squareWidth - (squareWidth - length) / 2.0))
        var angle = Float.pi
        path.move(to: point)

        for _ in 0..<sides {

            let x = Float(point.x) + (sideLength - offset * 2.0) * cosf(angle)
            let y = Float(point.y) + (sideLength - offset * 2.0) * sinf(angle)

            point = CGPoint(x: CGFloat(x), y: CGFloat(y))
            path.addLine(to: point)

            let centerX = Float(point.x) + cornerRadius * cosf(angle + Float.pi / 2)
            let centerY = Float(point.y) + cornerRadius * sinf(angle + Float.pi / 2)

            let center = CGPoint(x: CGFloat(centerX), y: CGFloat(centerY))

            let startAngle = CGFloat(angle) - CGFloat.pi / 2
            let endAngle = CGFloat(angle) + CGFloat(theta) - CGFloat.pi / 2

            path.addArc(withCenter: center,
                        radius: CGFloat(cornerRadius),
                        startAngle: startAngle,
                        endAngle: endAngle,
                        clockwise: true)

            point = path.currentPoint
            angle += theta
        }

        path.close()

        return path
    }
}
