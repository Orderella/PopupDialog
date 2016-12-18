//
//  TZStackView.swift
//  TZStackView
//
//  Created by Tom van Zummeren on 10/06/15.
//  Copyright © 2015 Tom van Zummeren. All rights reserved.
//

import UIKit

struct TZAnimationDidStopQueueEntry: Equatable {
    let view: UIView
    let hidden: Bool
}

func ==(lhs: TZAnimationDidStopQueueEntry, rhs: TZAnimationDidStopQueueEntry) -> Bool {
    return lhs.view === rhs.view
}

public class TZStackView: UIView {

    public var distribution: TZStackViewDistribution = .fill {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    public var axis: UILayoutConstraintAxis = .horizontal {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    public var alignment: TZStackViewAlignment = .fill

    public var spacing: CGFloat = 0
    
    public var layoutMarginsRelativeArrangement = false

    public private(set) var arrangedSubviews: [UIView] = [] {
        didSet {
            setNeedsUpdateConstraints()
            registerHiddenListeners(oldValue)
        }
    }

    private var kvoContext = UInt8()

    private var stackViewConstraints = [NSLayoutConstraint]()
    private var subviewConstraints = [NSLayoutConstraint]()

    private var spacerViews = [UIView]()
    
    private var animationDidStopQueueEntries = [TZAnimationDidStopQueueEntry]()
    
    private var registeredKvoSubviews = [UIView]()
    
    private var animatingToHiddenViews = [UIView]()

    public init(arrangedSubviews: [UIView] = []) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        for arrangedSubview in arrangedSubviews {
            arrangedSubview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(arrangedSubview)
        }

        // Closure to invoke didSet()
        { self.arrangedSubviews = arrangedSubviews }()
    }
    
    deinit {
        // This removes `hidden` value KVO observers using didSet()
        { self.arrangedSubviews = [] }()
    }
    
    private func registerHiddenListeners(_ previousArrangedSubviews: [UIView]) {
        for subview in previousArrangedSubviews {
            self.removeHiddenListener(subview)
        }

        for subview in arrangedSubviews {
            self.addHiddenListener(subview)
        }
    }
    
    private func addHiddenListener(_ view: UIView) {
        view.addObserver(self, forKeyPath: "hidden", options: [.old, .new], context: &kvoContext)
        registeredKvoSubviews.append(view)
    }
    
    private func removeHiddenListener(_ view: UIView) {
        if let index = registeredKvoSubviews.index(of: view) {
            view.removeObserver(self, forKeyPath: "hidden", context: &kvoContext)
            registeredKvoSubviews.remove(at: index)
        }
    }

    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let view = object as? UIView, let change = change, keyPath == "hidden" {
            let hidden = view.isHidden
            let previousValue = change[.oldKey] as! Bool
            if hidden == previousValue {
                return
            }
            if hidden {
                animatingToHiddenViews.append(view)
            }
            // Perform the animation
            setNeedsUpdateConstraints()
            setNeedsLayout()
            layoutIfNeeded()
            
            removeHiddenListener(view)
            view.isHidden = false

            if let _ = view.layer.animationKeys() {
                UIView.setAnimationDelegate(self)
                animationDidStopQueueEntries.insert(TZAnimationDidStopQueueEntry(view: view, hidden: hidden), at: 0)
                UIView.setAnimationDidStop(#selector(TZStackView.hiddenAnimationStopped))
            } else {
                didFinishSettingHiddenValue(view, hidden: hidden)
            }
        }
    }
    
    private func didFinishSettingHiddenValue(_ arrangedSubview: UIView, hidden: Bool) {
        arrangedSubview.isHidden = hidden
        if let index = animatingToHiddenViews.index(of: arrangedSubview) {
            animatingToHiddenViews.remove(at: index)
        }
        addHiddenListener(arrangedSubview)
    }

    func hiddenAnimationStopped() {
        var queueEntriesToRemove = [TZAnimationDidStopQueueEntry]()
        for entry in animationDidStopQueueEntries {
            let view = entry.view
            if view.layer.animationKeys() == nil {
                didFinishSettingHiddenValue(view, hidden: entry.hidden)
                queueEntriesToRemove.append(entry)
            }
        }
        for entry in queueEntriesToRemove {
            if let index = animationDidStopQueueEntries.index(of: entry) {
                animationDidStopQueueEntries.remove(at: index)
            }
        }
    }
    
    public func addArrangedSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        arrangedSubviews.append(view)
    }
    
    public func removeArrangedSubview(_ view: UIView) {
        if let index = arrangedSubviews.index(of: view) {
            arrangedSubviews.remove(at: index)
        }
    }

    public func insertArrangedSubview(_ view: UIView, at stackIndex: Int) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        arrangedSubviews.insert(view, at: stackIndex)
    }

    override public func willRemoveSubview(_ subview: UIView) {
        removeArrangedSubview(subview)
    }

    override public func updateConstraints() {
        removeConstraints(stackViewConstraints)
        stackViewConstraints.removeAll()

        for arrangedSubview in arrangedSubviews {
            arrangedSubview.removeConstraints(subviewConstraints)
        }
        subviewConstraints.removeAll()
        for arrangedSubview in arrangedSubviews {
            
            if alignment != .fill {
                let guideConstraint: NSLayoutConstraint
                switch axis {
                case .horizontal:
                    guideConstraint = constraint(item: arrangedSubview, attribute: .height, toItem: nil, attribute: .notAnAttribute, constant: 0, priority: 25)
                case .vertical:
                    guideConstraint = constraint(item: arrangedSubview, attribute: .width, toItem: nil, attribute: .notAnAttribute, constant: 0, priority: 25)
                }
                subviewConstraints.append(guideConstraint)
                arrangedSubview.addConstraint(guideConstraint)
            }
            
            if isHidden(arrangedSubview) {
                let hiddenConstraint: NSLayoutConstraint
                switch axis {
                case .horizontal:
                    hiddenConstraint = constraint(item: arrangedSubview, attribute: .width, toItem: nil, attribute: .notAnAttribute, constant: 0)
                case .vertical:
                    hiddenConstraint = constraint(item: arrangedSubview, attribute: .height, toItem: nil, attribute: .notAnAttribute, constant: 0)
                }
                subviewConstraints.append(hiddenConstraint)
                arrangedSubview.addConstraint(hiddenConstraint)
            }
        }
        
        for spacerView in spacerViews {
            spacerView.removeFromSuperview()
        }
        spacerViews.removeAll()
        
        if arrangedSubviews.count > 0 {
            
            let visibleArrangedSubviews = arrangedSubviews.filter({!self.isHidden($0)})
            
            switch distribution {
            case .fillEqually, .fill, .fillProportionally:
                if alignment != .fill || layoutMarginsRelativeArrangement {
                    _ = addSpacerView()
                }

                stackViewConstraints += createMatchEdgesContraints(arrangedSubviews)
                stackViewConstraints += createFirstAndLastViewMatchEdgesContraints()
                
                if alignment == .firstBaseline && axis == .horizontal {
                    stackViewConstraints.append(constraint(item: self, attribute: .height, toItem: nil, attribute: .notAnAttribute, priority: 49))
                }

                if distribution == .fillEqually {
                    stackViewConstraints += createFillEquallyConstraints(arrangedSubviews)
                }
                if distribution == .fillProportionally {
                    stackViewConstraints += createFillProportionallyConstraints(arrangedSubviews)
                }
                
                stackViewConstraints += createFillConstraints(arrangedSubviews, constant: spacing)
            case .equalSpacing:
                var views = [UIView]()
                var index = 0
                for arrangedSubview in arrangedSubviews {
                    if isHidden(arrangedSubview) {
                        continue
                    }
                    if index > 0 {
                        views.append(addSpacerView())
                    }
                    views.append(arrangedSubview)
                    index += 1
                }
                if spacerViews.count == 0 {
                    _ = addSpacerView()
                }
                
                stackViewConstraints += createMatchEdgesContraints(arrangedSubviews)
                stackViewConstraints += createFirstAndLastViewMatchEdgesContraints()
                
                switch axis {
                case .horizontal:
                    stackViewConstraints.append(constraint(item: self, attribute: .width, toItem: nil, attribute: .notAnAttribute, priority: 49))
                    if alignment == .firstBaseline {
                        stackViewConstraints.append(constraint(item: self, attribute: .height, toItem: nil, attribute: .notAnAttribute, priority: 49))
                    }
                case .vertical:
                    stackViewConstraints.append(constraint(item: self, attribute: .height, toItem: nil, attribute: .notAnAttribute, priority: 49))
                }

                stackViewConstraints += createFillConstraints(views, constant: 0)
                stackViewConstraints += createFillEquallyConstraints(spacerViews)
                stackViewConstraints += createFillConstraints(arrangedSubviews, relatedBy: .greaterThanOrEqual, constant: spacing)
            case .equalCentering:
                for (index, _) in visibleArrangedSubviews.enumerated() {
                    if index > 0 {
                        _ = addSpacerView()
                    }
                }
                if spacerViews.count == 0 {
                    _ = addSpacerView()
                }
                
                stackViewConstraints += createMatchEdgesContraints(arrangedSubviews)
                stackViewConstraints += createFirstAndLastViewMatchEdgesContraints()
                
                switch axis {
                case .horizontal:
                    stackViewConstraints.append(constraint(item: self, attribute: .width, toItem: nil, attribute: .notAnAttribute, priority: 49))
                    if alignment == .firstBaseline {
                        stackViewConstraints.append(constraint(item: self, attribute: .height, toItem: nil, attribute: .notAnAttribute, priority: 49))
                    }
                case .vertical:
                    stackViewConstraints.append(constraint(item: self, attribute: .height, toItem: nil, attribute: .notAnAttribute, priority: 49))
                }

                var previousArrangedSubview: UIView?
                for (index, arrangedSubview) in visibleArrangedSubviews.enumerated() {
                    if let previousArrangedSubview = previousArrangedSubview {
                        let spacerView = spacerViews[index - 1]
                        
                        switch axis {
                        case .horizontal:
                            stackViewConstraints.append(constraint(item: previousArrangedSubview, attribute: .centerX, toItem: spacerView, attribute: .leading))
                            stackViewConstraints.append(constraint(item: arrangedSubview, attribute: .centerX, toItem: spacerView, attribute: .trailing))
                        case .vertical:
                            stackViewConstraints.append(constraint(item: previousArrangedSubview, attribute: .centerY, toItem: spacerView, attribute: .top))
                            stackViewConstraints.append(constraint(item: arrangedSubview, attribute: .centerY, toItem: spacerView, attribute: .bottom))
                        }
                    }
                    previousArrangedSubview = arrangedSubview
                }

                stackViewConstraints += createFillEquallyConstraints(spacerViews, priority: 150)
                stackViewConstraints += createFillConstraints(arrangedSubviews, relatedBy: .greaterThanOrEqual, constant: spacing)
            }
            
            if spacerViews.count > 0 {
                stackViewConstraints += createSurroundingSpacerViewConstraints(spacerViews[0], views: visibleArrangedSubviews)
            }

            if layoutMarginsRelativeArrangement {
                if spacerViews.count > 0 {
                    stackViewConstraints.append(constraint(item: self, attribute: .bottomMargin, toItem: spacerViews[0], attribute: .bottom))
                    stackViewConstraints.append(constraint(item: self, attribute: .leftMargin, toItem: spacerViews[0], attribute: .left))
                    stackViewConstraints.append(constraint(item: self, attribute: .rightMargin, toItem: spacerViews[0], attribute: .right))
                    stackViewConstraints.append(constraint(item: self, attribute: .topMargin, toItem: spacerViews[0], attribute: .top))
                }
            }
            addConstraints(stackViewConstraints)
        }

        super.updateConstraints()
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    private func addSpacerView() -> TZSpacerView {
        let spacerView = TZSpacerView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        
        spacerViews.append(spacerView)
        insertSubview(spacerView, at: 0)
        return spacerView
    }
    
    private func createSurroundingSpacerViewConstraints(_ spacerView: UIView, views: [UIView]) -> [NSLayoutConstraint] {
        if alignment == .fill {
            return []
        }
        
        var topPriority: Float = 1000
        var topRelation: NSLayoutRelation = .lessThanOrEqual
        
        var bottomPriority: Float = 1000
        var bottomRelation: NSLayoutRelation = .greaterThanOrEqual
        
        if alignment == .top || alignment == .leading {
            topPriority = 999.5
            topRelation = .equal
        }
        
        if alignment == .bottom || alignment == .trailing {
            bottomPriority = 999.5
            bottomRelation = .equal
        }
        
        var constraints = [NSLayoutConstraint]()
        for view in views {
            switch axis {
            case .horizontal:
                constraints.append(constraint(item: spacerView, attribute: .top, relatedBy: topRelation, toItem: view, priority: topPriority))
                constraints.append(constraint(item: spacerView, attribute: .bottom, relatedBy: bottomRelation, toItem: view, priority: bottomPriority))
            case .vertical:
                constraints.append(constraint(item: spacerView, attribute: .leading, relatedBy: topRelation, toItem: view, priority: topPriority))
                constraints.append(constraint(item: spacerView, attribute: .trailing, relatedBy: bottomRelation, toItem: view, priority: bottomPriority))
            }
        }
        switch axis {
        case .horizontal:
            constraints.append(constraint(item: spacerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, constant: 0, priority: 51))
        case .vertical:
            constraints.append(constraint(item: spacerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, constant: 0, priority: 51))
        }
        return constraints
    }
    
    private func createFillProportionallyConstraints(_ views: [UIView]) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        var totalSize: CGFloat = 0
        var totalCount = 0
        for arrangedSubview in views {
            if isHidden(arrangedSubview) {
                continue
            }
            switch axis {
            case .horizontal:
                totalSize += arrangedSubview.intrinsicContentSize.width
            case .vertical:
                totalSize += arrangedSubview.intrinsicContentSize.height
            }
            totalCount += 1
        }
        totalSize += (CGFloat(totalCount - 1) * spacing)
        
        var priority: Float = 1000
        let countDownPriority = (views.filter({!self.isHidden($0)}).count > 1)
        for arrangedSubview in views {
            if countDownPriority {
                priority -= 1
            }
            
            if isHidden(arrangedSubview) {
                continue
            }
            switch axis {
            case .horizontal:
                let multiplier = arrangedSubview.intrinsicContentSize.width / totalSize
                constraints.append(constraint(item: arrangedSubview, attribute: .width, toItem: self, multiplier: multiplier, priority: priority))
            case .vertical:
                let multiplier = arrangedSubview.intrinsicContentSize.height / totalSize
                constraints.append(constraint(item: arrangedSubview, attribute: .height, toItem: self, multiplier: multiplier, priority: priority))
            }
        }
        
        return constraints
    }
    
    // Matchs all Width or Height attributes of all given views
    private func createFillEquallyConstraints(_ views: [UIView], priority: Float = 1000) -> [NSLayoutConstraint] {
        switch axis {
        case .horizontal:
            return equalAttributes(views: views.filter({ !self.isHidden($0) }), attribute: .width, priority: priority)
            
        case .vertical:
            return equalAttributes(views: views.filter({ !self.isHidden($0) }), attribute: .height, priority: priority)
        }
    }
    
    // Chains together the given views using Leading/Trailing or Top/Bottom
    private func createFillConstraints(_ views: [UIView], priority: Float = 1000, relatedBy relation: NSLayoutRelation = .equal, constant: CGFloat) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        var previousView: UIView?
        for view in views {
            if let previousView = previousView {
                var c: CGFloat = 0
                if !isHidden(previousView) && !isHidden(view) {
                    c = constant
                } else if isHidden(previousView) && !isHidden(view) && views.first != previousView {
                    c = (constant / 2)
                } else if isHidden(view) && !isHidden(previousView) && views.last != view {
                    c = (constant / 2)
                }
                switch axis {
                case .horizontal:
                    constraints.append(constraint(item: view, attribute: .leading, relatedBy: relation, toItem: previousView, attribute: .trailing, constant: c, priority: priority))
                    
                case .vertical:
                    constraints.append(constraint(item: view, attribute: .top, relatedBy: relation, toItem: previousView, attribute: .bottom, constant: c, priority: priority))
                }
            }
            previousView = view
        }
        return constraints
    }
    
    // Matches all Bottom/Top or Leading Trailing constraints of te given views and matches those attributes of the first/last view to the container
    private func createMatchEdgesContraints(_ views: [UIView]) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        switch axis {
        case .horizontal:
            switch alignment {
            case .fill:
                constraints += equalAttributes(views: views, attribute: .bottom)
                constraints += equalAttributes(views: views, attribute: .top)
            case .center:
                constraints += equalAttributes(views: views, attribute: .centerY)
            case .leading, .top:
                constraints += equalAttributes(views: views, attribute: .top)
            case .trailing, .bottom:
                constraints += equalAttributes(views: views, attribute: .bottom)
            case .firstBaseline:
                constraints += equalAttributes(views: views, attribute: .firstBaseline)
            }
            
        case .vertical:
            switch alignment {
            case .fill:
                constraints += equalAttributes(views: views, attribute: .leading)
                constraints += equalAttributes(views: views, attribute: .trailing)
            case .center:
                constraints += equalAttributes(views: views, attribute: .centerX)
            case .leading, .top:
                constraints += equalAttributes(views: views, attribute: .leading)
            case .trailing, .bottom:
                constraints += equalAttributes(views: views, attribute: .trailing)
            case .firstBaseline:
                constraints += []
            }
        }
        return constraints
    }
    
    private func createFirstAndLastViewMatchEdgesContraints() -> [NSLayoutConstraint] {
        
        var constraints = [NSLayoutConstraint]()
        
        let visibleViews = arrangedSubviews.filter({!self.isHidden($0)})
        let firstView = visibleViews.first
        let lastView = visibleViews.last

        var topView = arrangedSubviews.first!
        var bottomView = arrangedSubviews.first!
        if spacerViews.count > 0 {
            if alignment == .center {
                topView = spacerViews[0]
                bottomView = spacerViews[0]
            } else if alignment == .top || alignment == .leading {
                bottomView = spacerViews[0]
            } else if alignment == .bottom || alignment == .trailing {
                topView = spacerViews[0]
            } else if alignment == .firstBaseline {
                switch axis {
                case .horizontal:
                    bottomView = spacerViews[0]
                case .vertical:
                    topView = spacerViews[0]
                    bottomView = spacerViews[0]
                }
            }
        }
        
        let firstItem = layoutMarginsRelativeArrangement ? spacerViews[0] : self

        switch axis {
        case .horizontal:
            if let firstView = firstView {
                constraints.append(constraint(item: firstItem, attribute: .leading, toItem: firstView))
            }
            if let lastView = lastView {
                constraints.append(constraint(item: firstItem, attribute: .trailing, toItem: lastView))
            }
            
            constraints.append(constraint(item: firstItem, attribute: .top, toItem: topView))
            constraints.append(constraint(item: firstItem, attribute: .bottom, toItem: bottomView))

            if alignment == .center {
                constraints.append(constraint(item: firstItem, attribute: .centerY, toItem: arrangedSubviews.first!))
            }
        case .vertical:
            if let firstView = firstView {
                constraints.append(constraint(item: firstItem, attribute: .top, toItem: firstView))
            }
            if let lastView = lastView {
                constraints.append(constraint(item: firstItem, attribute: .bottom, toItem: lastView))
            }

            constraints.append(constraint(item: firstItem, attribute: .leading, toItem: topView))
            constraints.append(constraint(item: firstItem, attribute: .trailing, toItem: bottomView))

            if alignment == .center {
                constraints.append(constraint(item: firstItem, attribute: .centerX, toItem: arrangedSubviews.first!))
            }
        }
        
        return constraints
    }
    
    private func equalAttributes(views: [UIView], attribute: NSLayoutAttribute, priority: Float = 1000) -> [NSLayoutConstraint] {
        var currentPriority = priority
        var constraints = [NSLayoutConstraint]()
        if views.count > 0 {
            
            var firstView: UIView?

            let countDownPriority = (currentPriority < 1000)
            for view in views {
                if let firstView = firstView {
                    constraints.append(constraint(item: firstView, attribute: attribute, toItem: view, priority: currentPriority))
                } else {
                    firstView = view
                }
                if countDownPriority {
                    currentPriority -= 1
                }
            }
        }
        return constraints
    }

    // Convenience method to help make NSLayoutConstraint in a less verbose way
    private func constraint(item view1: AnyObject, attribute attr1: NSLayoutAttribute, relatedBy relation: NSLayoutRelation = .equal, toItem view2: AnyObject?, attribute attr2: NSLayoutAttribute? = nil, multiplier: CGFloat = 1, constant c: CGFloat = 0, priority: Float = 1000) -> NSLayoutConstraint {

        let attribute2 = attr2 != nil ? attr2! : attr1

        let constraint = NSLayoutConstraint(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attribute2, multiplier: multiplier, constant: c)
        constraint.priority = priority
        return constraint
    }
    
    private func isHidden(_ view: UIView) -> Bool {
        if view.isHidden {
            return true
        }
        return animatingToHiddenViews.index(of: view) != nil
    }
}
