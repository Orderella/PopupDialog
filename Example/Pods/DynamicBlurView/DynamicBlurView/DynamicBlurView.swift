//
//  DynamicBlurView.swift
//  DynamicBlurView
//
//  Created by Kyohei Ito on 2015/04/08.
//  Copyright (c) 2015年 kyohei_ito. All rights reserved.
//

import UIKit

open class DynamicBlurView: UIView {
    open override class var layerClass : AnyClass {
        return BlurLayer.self
    }

    private var staticImage: UIImage?
    private var displayLink: CADisplayLink?
    private var blurLayer: BlurLayer {
        return layer as! BlurLayer
    }
    private let mainQueue = DispatchQueue.main
    private let globalQueue: DispatchQueue = {
        if #available (iOS 8.0, *) {
            return .global(qos: .userInteractive)
        } else {
            return .global(priority: .high)
        }
    }()
    private var renderingTarget: UIView? {
        if isDeepRendering {
            return window
        } else {
            return superview
        }
    }

    /// When true, it captures displays image and blur it asynchronously. Try to set true if needs more performance.
    /// Asynchronous drawing is possibly crash when needs to process on main thread that drawing with animation for example.
    open var drawsAsynchronously: Bool = false
    /// Radius of blur.
    open var blurRadius: CGFloat {
        set { blurLayer.blurRadius = newValue }
        get { return blurLayer.blurRadius }
    }
    /// Default is none.
    open var trackingMode: TrackingMode = .none {
        didSet {
            if trackingMode != oldValue {
                linkForDisplay()
            }
        }
    }
    /// Blend color.
    open var blendColor: UIColor?
	/// Blend mode.
    open var blendMode: CGBlendMode = .plusLighter
    /// Default is 3.
    open var iterations: Int = 3
    /// If the view want to render beyond the layer, should be true.
    open var isDeepRendering: Bool = false
    /// When none of tracking mode, it can change the radius of blur with the ratio. Should set from 0 to 1.
    open var blurRatio: CGFloat = 1 {
        didSet {
            if let image = staticImage, oldValue != blurRatio {
                draw(image, blurRadius: blurRadius, fixes: false, baseLayer: renderingTarget?.layer)
            }
        }
    }
    /// Quality of captured image.
    open var quality: CaptureQuality = .medium

    public override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isUserInteractionEnabled = false
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()

        if let view = renderingTarget, window != nil && trackingMode == .none {
            staticImage = snapshotImage(for: view.layer, conversion: !isDeepRendering)
        }
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()

        if superview == nil {
            displayLink?.invalidate()
            displayLink = nil
        } else {
            linkForDisplay()
        }
    }

    private func async(on queue: DispatchQueue, actions: @escaping () -> Void) {
        if drawsAsynchronously {
            queue.async(execute: actions)
        } else {
            actions()
        }
    }

    private func sync(on queue: DispatchQueue, actions: () -> Void) {
        if drawsAsynchronously {
            queue.sync(execute: actions)
        } else {
            actions()
        }
    }

    private func draw(_ image: UIImage, blurRadius radius: CGFloat, fixes isFixes: Bool, baseLayer: CALayer?) {
        async(on: globalQueue) { [weak self] in
            if let me = self, let blurredImage = image.blurred(radius: radius, iterations: me.iterations, ratio: me.blurRatio, blendColor: me.blendColor, blendMode: me.blendMode) {
                me.sync(on: me.mainQueue) {
                    me.blurLayer.draw(blurredImage, fixes: isFixes, baseLayer: baseLayer)
                }
            }
        }
    }

    private func blurLayerRect(to layer: CALayer, conversion: Bool) -> CGRect {
        if conversion {
            let presentationLayer = blurLayer.presentation() ?? blurLayer
            return presentationLayer.convert(presentationLayer.bounds, to: layer)
        } else {
            return layer.bounds
        }
    }

    private func snapshotImage(for layer: CALayer, conversion: Bool) -> UIImage? {
        let rect = blurLayerRect(to: layer, conversion: conversion)
        guard let context = CGContext.imageContext(with: quality, rect: rect, opaque: isOpaque) else {
            return nil
        }

        blurLayer.render(in: context, for: layer)

        defer {
            UIGraphicsEndImageContext()
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension DynamicBlurView {
    open override func display(_ layer: CALayer) {
        let blurRadius = blurLayer.presentationRadius
        let isFixes = isDeepRendering && staticImage != nil
        if let view = renderingTarget, let image = staticImage ?? snapshotImage(for: view.layer, conversion: !isFixes) {
            draw(image, blurRadius: blurRadius, fixes: isFixes, baseLayer: view.layer)
        }
    }
}

extension DynamicBlurView {
    private func linkForDisplay() {
        displayLink?.invalidate()
        displayLink = UIScreen.main.displayLink(withTarget: self, selector: #selector(DynamicBlurView.displayDidRefresh(_:)))
        displayLink?.add(to: .main, forMode: RunLoop.Mode(rawValue: trackingMode.description))
    }

    @objc private func displayDidRefresh(_ displayLink: CADisplayLink) {
        display(layer)
    }
}

extension DynamicBlurView {
    /// Remove cache of blur image then get it again.
    open func refresh() {
        blurLayer.refresh()
        staticImage = nil
        blurRatio = 1
        display(layer)
    }

    /// Remove cache of blur image.
    open func remove() {
        blurLayer.refresh()
        staticImage = nil
        blurRatio = 1
        layer.contents = nil
    }

    /// Should use when needs to change layout with animation when is set none of tracking mode.
    public func animate() {
        blurLayer.animate()
    }
}
