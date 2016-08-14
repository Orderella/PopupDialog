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

    public var distribution: TZStackViewDistribution = .Fill {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    public var axis: UILayoutConstraintAxis = .Horizontal {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    public var alignment: TZStackViewAlignment = .Fill

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
        super.init(frame: CGRectZero)
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
    
    private func registerHiddenListeners(previousArrangedSubviews: [UIView]) {
        for subview in previousArrangedSubviews {
            self.removeHiddenListener(subview)
        }

        for subview in arrangedSubviews {
            self.addHiddenListener(subview)
        }
    }
    
    private func addHiddenListener(view: UIView) {
        view.addObserver(self, forKeyPath: "hidden", options: [.Old, .New], context: &kvoContext)
        registeredKvoSubviews.append(view)
    }
    
    private func removeHiddenListener(view: UIView) {
        if let index = registeredKvoSubviews.indexOf(view) {
            view.removeObserver(self, forKeyPath: "hidden", context: &kvoContext)
            registeredKvoSubviews.removeAtIndex(index)
        }
    }

    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let view = object as? UIView, change = change where keyPath == "hidden" {
            let hidden = view.hidden
            let previousValue = change["old"] as! Bool
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
            view.hidden = false

            if let _ = view.layer.animationKeys() {
                UIView.setAnimationDelegate(self)
                animationDidStopQueueEntries.insert(TZAnimationDidStopQueueEntry(view: view, hidden: hidden), atIndex: 0)
                UIView.setAnimationDidStopSelector(#selector(TZStackView.hiddenAnimationStopped))
            } else {
                didFinishSettingHiddenValue(view, hidden: hidden)
            }
        }
    }
    
    private func didFinishSettingHiddenValue(arrangedSubview: UIView, hidden: Bool) {
        arrangedSubview.hidden = hidden
        if let index = animatingToHiddenViews.indexOf(arrangedSubview) {
            animatingToHiddenViews.removeAtIndex(index)
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
            if let index = animationDidStopQueueEntries.indexOf(entry) {
                animationDidStopQueueEntries.removeAtIndex(index)
            }
        }
    }
    
    public func addArrangedSubview(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        arrangedSubviews.append(view)
    }
    
    public func removeArrangedSubview(view: UIView) {
        if let index = arrangedSubviews.indexOf(view) {
            arrangedSubviews.removeAtIndex(index)
        }
    }

    public func insertArrangedSubview(view: UIView, atIndex stackIndex: Int) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        arrangedSubviews.insert(view, atIndex: stackIndex)
    }

    override public func willRemoveSubview(subview: UIView) {
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
            
            if alignment != .Fill {
                let guideConstraint: NSLayoutConstraint
                switch axis {
                case .Horizontal:
                    guideConstraint = constraint(item: arrangedSubview, attribute: .Height, toItem: nil, attribute: .NotAnAttribute, constant: 0, priority: 25)
                case .Vertical:
                    guideConstraint = constraint(item: arrangedSubview, attribute: .Width, toItem: nil, attribute: .NotAnAttribute, constant: 0, priority: 25)
                }
                subviewConstraints.append(guideConstraint)
                arrangedSubview.addConstraint(guideConstraint)
            }
            
            if isHidden(arrangedSubview) {
                let hiddenConstraint: NSLayoutConstraint
                switch axis {
                case .Horizontal:
                    hiddenConstraint = constraint(item: arrangedSubview, attribute: .Width, toItem: nil, attribute: .NotAnAttribute, constant: 0)
                case .Vertical:
                    hiddenConstraint = constraint(item: arrangedSubview, attribute: .Height, toItem: nil, attribute: .NotAnAttribute, constant: 0)
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
            case .FillEqually, .Fill, .FillProportionally:
                if alignment != .Fill || layoutMarginsRelativeArrangement {
                    addSpacerView()
                }

                stackViewConstraints += createMatchEdgesContraints(arrangedSubviews)
                stackViewConstraints += createFirstAndLastViewMatchEdgesContraints()
                
                if alignment == .FirstBaseline && axis == .Horizontal {
                    stackViewConstraints.append(constraint(item: self, attribute: .Height, toItem: nil, attribute: .NotAnAttribute, priority: 49))
                }

                if distribution == .FillEqually {
                    stackViewConstraints += createFillEquallyConstraints(arrangedSubviews)
                }
                if distribution == .FillProportionally {
                    stackViewConstraints += createFillProportionallyConstraints(arrangedSubviews)
                }
                
                stackViewConstraints += createFillConstraints(arrangedSubviews, constant: spacing)
            case .EqualSpacing:
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
                    addSpacerView()
                }
                
                stackViewConstraints += createMatchEdgesContraints(arrangedSubviews)
                stackViewConstraints += createFirstAndLastViewMatchEdgesContraints()
                
                switch axis {
                case .Horizontal:
                    stackViewConstraints.append(constraint(item: self, attribute: .Width, toItem: nil, attribute: .NotAnAttribute, priority: 49))
                    if alignment == .FirstBaseline {
                        stackViewConstraints.append(constraint(item: self, attribute: .Height, toItem: nil, attribute: .NotAnAttribute, priority: 49))
                    }
                case .Vertical:
                    stackViewConstraints.append(constraint(item: self, attribute: .Height, toItem: nil, attribute: .NotAnAttribute, priority: 49))
                }

                stackViewConstraints += createFillConstraints(views, constant: 0)
                stackViewConstraints += createFillEquallyConstraints(spacerViews)
                stackViewConstraints += createFillConstraints(arrangedSubviews, relatedBy: .GreaterThanOrEqual, constant: spacing)
            case .EqualCentering:
                for (index, _) in visibleArrangedSubviews.enumerate() {
                    if index > 0 {
                        addSpacerView()
                    }
                }
                if spacerViews.count == 0 {
                    addSpacerView()
                }
                
                stackViewConstraints += createMatchEdgesContraints(arrangedSubviews)
                stackViewConstraints += createFirstAndLastViewMatchEdgesContraints()
                
                switch axis {
                case .Horizontal:
                    stackViewConstraints.append(constraint(item: self, attribute: .Width, toItem: nil, attribute: .NotAnAttribute, priority: 49))
                    if alignment == .FirstBaseline {
                        stackViewConstraints.append(constraint(item: self, attribute: .Height, toItem: nil, attribute: .NotAnAttribute, priority: 49))
                    }
                case .Vertical:
                    stackViewConstraints.append(constraint(item: self, attribute: .Height, toItem: nil, attribute: .NotAnAttribute, priority: 49))
                }

                var previousArrangedSubview: UIView?
                for (index, arrangedSubview) in visibleArrangedSubviews.enumerate() {
                    if let previousArrangedSubview = previousArrangedSubview {
                        let spacerView = spacerViews[index - 1]
                        
                        switch axis {
                        case .Horizontal:
                            stackViewConstraints.append(constraint(item: previousArrangedSubview, attribute: .CenterX, toItem: spacerView, attribute: .Leading))
                            stackViewConstraints.append(constraint(item: arrangedSubview, attribute: .CenterX, toItem: spacerView, attribute: .Trailing))
                        case .Vertical:
                            stackViewConstraints.append(constraint(item: previousArrangedSubview, attribute: .CenterY, toItem: spacerView, attribute: .Top))
                            stackViewConstraints.append(constraint(item: arrangedSubview, attribute: .CenterY, toItem: spacerView, attribute: .Bottom))
                        }
                    }
                    previousArrangedSubview = arrangedSubview
                }

                stackViewConstraints += createFillEquallyConstraints(spacerViews, priority: 150)
                stackViewConstraints += createFillConstraints(arrangedSubviews, relatedBy: .GreaterThanOrEqual, constant: spacing)
            }
            
            if spacerViews.count > 0 {
                stackViewConstraints += createSurroundingSpacerViewConstraints(spacerViews[0], views: visibleArrangedSubviews)
            }

            if layoutMarginsRelativeArrangement {
                if spacerViews.count > 0 {
                    stackViewConstraints.append(constraint(item: self, attribute: .BottomMargin, toItem: spacerViews[0], attribute: .Bottom))
                    stackViewConstraints.append(constraint(item: self, attribute: .LeftMargin, toItem: spacerViews[0], attribute: .Left))
                    stackViewConstraints.append(constraint(item: self, attribute: .RightMargin, toItem: spacerViews[0], attribute: .Right))
                    stackViewConstraints.append(constraint(item: self, attribute: .TopMargin, toItem: spacerViews[0], attribute: .Top))
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
        insertSubview(spacerView, atIndex: 0)
        return spacerView
    }
    
    private func createSurroundingSpacerViewConstraints(spacerView: UIView, views: [UIView]) -> [NSLayoutConstraint] {
        if alignment == .Fill {
            return []
        }
        
        var topPriority: Float = 1000
        var topRelation: NSLayoutRelation = .LessThanOrEqual
        
        var bottomPriority: Float = 1000
        var bottomRelation: NSLayoutRelation = .GreaterThanOrEqual
        
        if alignment == .Top || alignment == .Leading {
            topPriority = 999.5
            topRelation = .Equal
        }
        
        if alignment == .Bottom || alignment == .Trailing {
            bottomPriority = 999.5
            bottomRelation = .Equal
        }
        
        var constraints = [NSLayoutConstraint]()
        for view in views {
            switch axis {
            case .Horizontal:
                constraints.append(constraint(item: spacerView, attribute: .Top, relatedBy: topRelation, toItem: view, priority: topPriority))
                constraints.append(constraint(item: spacerView, attribute: .Bottom, relatedBy: bottomRelation, toItem: view, priority: bottomPriority))
            case .Vertical:
                constraints.append(constraint(item: spacerView, attribute: .Leading, relatedBy: topRelation, toItem: view, priority: topPriority))
                constraints.append(constraint(item: spacerView, attribute: .Trailing, relatedBy: bottomRelation, toItem: view, priority: bottomPriority))
            }
        }
        switch axis {
        case .Horizontal:
            constraints.append(constraint(item: spacerView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, constant: 0, priority: 51))
        case .Vertical:
            constraints.append(constraint(item: spacerView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, constant: 0, priority: 51))
        }
        return constraints
    }
    
    private func createFillProportionallyConstraints(views: [UIView]) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        var totalSize: CGFloat = 0
        var totalCount = 0
        for arrangedSubview in views {
            if isHidden(arrangedSubview) {
                continue
            }
            switch axis {
            case .Horizontal:
                totalSize += arrangedSubview.intrinsicContentSize().width
            case .Vertical:
                totalSize += arrangedSubview.intrinsicContentSize().height
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
            case .Horizontal:
                let multiplier = arrangedSubview.intrinsicContentSize().width / totalSize
                constraints.append(constraint(item: arrangedSubview, attribute: .Width, toItem: self, multiplier: multiplier, priority: priority))
            case .Vertical:
                let multiplier = arrangedSubview.intrinsicContentSize().height / totalSize
                constraints.append(constraint(item: arrangedSubview, attribute: .Height, toItem: self, multiplier: multiplier, priority: priority))
            }
        }
        
        return constraints
    }
    
    // Matchs all Width or Height attributes of all given views
    private func createFillEquallyConstraints(views: [UIView], priority: Float = 1000) -> [NSLayoutConstraint] {
        switch axis {
        case .Horizontal:
            return equalAttributes(views: views.filter({ !self.isHidden($0) }), attribute: .Width, priority: priority)
            
        case .Vertical:
            return equalAttributes(views: views.filter({ !self.isHidden($0) }), attribute: .Height, priority: priority)
        }
    }
    
    // Chains together the given views using Leading/Trailing or Top/Bottom
    private func createFillConstraints(views: [UIView], priority: Float = 1000, relatedBy relation: NSLayoutRelation = .Equal, constant: CGFloat) -> [NSLayoutConstraint] {
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
                case .Horizontal:
                    constraints.append(constraint(item: view, attribute: .Leading, relatedBy: relation, toItem: previousView, attribute: .Trailing, constant: c, priority: priority))
                    
                case .Vertical:
                    constraints.append(constraint(item: view, attribute: .Top, relatedBy: relation, toItem: previousView, attribute: .Bottom, constant: c, priority: priority))
                }
            }
            previousView = view
        }
        return constraints
    }
    
    // Matches all Bottom/Top or Leading Trailing constraints of te given views and matches those attributes of the first/last view to the container
    private func createMatchEdgesContraints(views: [UIView]) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        switch axis {
        case .Horizontal:
            switch alignment {
            case .Fill:
                constraints += equalAttributes(views: views, attribute: .Bottom)
                constraints += equalAttributes(views: views, attribute: .Top)
            case .Center:
                constraints += equalAttributes(views: views, attribute: .CenterY)
            case .Leading, .Top:
                constraints += equalAttributes(views: views, attribute: .Top)
            case .Trailing, .Bottom:
                constraints += equalAttributes(views: views, attribute: .Bottom)
            case .FirstBaseline:
                constraints += equalAttributes(views: views, attribute: .FirstBaseline)
            }
            
        case .Vertical:
            switch alignment {
            case .Fill:
                constraints += equalAttributes(views: views, attribute: .Leading)
                constraints += equalAttributes(views: views, attribute: .Trailing)
            case .Center:
                constraints += equalAttributes(views: views, attribute: .CenterX)
            case .Leading, .Top:
                constraints += equalAttributes(views: views, attribute: .Leading)
            case .Trailing, .Bottom:
                constraints += equalAttributes(views: views, attribute: .Trailing)
            case .FirstBaseline:
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
            if alignment == .Center {
                topView = spacerViews[0]
                bottomView = spacerViews[0]
            } else if alignment == .Top || alignment == .Leading {
                bottomView = spacerViews[0]
            } else if alignment == .Bottom || alignment == .Trailing {
                topView = spacerViews[0]
            } else if alignment == .FirstBaseline {
                switch axis {
                case .Horizontal:
                    bottomView = spacerViews[0]
                case .Vertical:
                    topView = spacerViews[0]
                    bottomView = spacerViews[0]
                }
            }
        }
        
        let firstItem = layoutMarginsRelativeArrangement ? spacerViews[0] : self

        switch axis {
        case .Horizontal:
            if let firstView = firstView {
                constraints.append(constraint(item: firstItem, attribute: .Leading, toItem: firstView))
            }
            if let lastView = lastView {
                constraints.append(constraint(item: firstItem, attribute: .Trailing, toItem: lastView))
            }
            
            constraints.append(constraint(item: firstItem, attribute: .Top, toItem: topView))
            constraints.append(constraint(item: firstItem, attribute: .Bottom, toItem: bottomView))

            if alignment == .Center {
                constraints.append(constraint(item: firstItem, attribute: .CenterY, toItem: arrangedSubviews.first!))
            }
        case .Vertical:
            if let firstView = firstView {
                constraints.append(constraint(item: firstItem, attribute: .Top, toItem: firstView))
            }
            if let lastView = lastView {
                constraints.append(constraint(item: firstItem, attribute: .Bottom, toItem: lastView))
            }

            constraints.append(constraint(item: firstItem, attribute: .Leading, toItem: topView))
            constraints.append(constraint(item: firstItem, attribute: .Trailing, toItem: bottomView))

            if alignment == .Center {
                constraints.append(constraint(item: firstItem, attribute: .CenterX, toItem: arrangedSubviews.first!))
            }
        }
        
        return constraints
    }
    
    private func equalAttributes(views views: [UIView], attribute: NSLayoutAttribute, priority: Float = 1000) -> [NSLayoutConstraint] {
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
    private func constraint(item view1: AnyObject, attribute attr1: NSLayoutAttribute, relatedBy relation: NSLayoutRelation = .Equal, toItem view2: AnyObject?, attribute attr2: NSLayoutAttribute? = nil, multiplier: CGFloat = 1, constant c: CGFloat = 0, priority: Float = 1000) -> NSLayoutConstraint {

        let attribute2 = attr2 != nil ? attr2! : attr1

        let constraint = NSLayoutConstraint(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attribute2, multiplier: multiplier, constant: c)
        constraint.priority = priority
        return constraint
    }
    
    private func isHidden(view: UIView) -> Bool {
        if view.hidden {
            return true
        }
        return animatingToHiddenViews.indexOf(view) != nil
    }
}
