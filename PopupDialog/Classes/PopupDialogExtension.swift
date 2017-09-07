import UIKit

extension PopupDialog {
    public func animateTo(_ vc: UIViewController) {
        if #available(iOS 9.0, *) {
            let stackView = popupContainerView.stackView as! UIStackView
            let vcToRemove = childViewControllers[0]
            addChildViewController(vc)
            viewController = vc
            viewController.didMove(toParentViewController: self)
            vcToRemove.removeFromParentViewController()

            UIView.transition(with: popupContainerView.stackView, duration: 0.1, options: [.beginFromCurrentState], animations: { _ in
                stackView.removeArrangedSubview(vcToRemove.view)
                stackView.addArrangedSubview(vc.view)
            })
            UIView.transition(with: popupContainerView, duration: 0.35, options: [.transitionFlipFromRight], animations: nil)
        } else {
            let stackView = popupContainerView.stackView as! TZStackView
            let vcToRemove = childViewControllers[0]
            addChildViewController(vc)
            viewController = vc
            viewController.didMove(toParentViewController: self)
            vcToRemove.removeFromParentViewController()

            UIView.transition(with: popupContainerView.stackView, duration: 0.1, options: [.beginFromCurrentState], animations: { _ in
                stackView.removeArrangedSubview(vcToRemove.view)
                stackView.addArrangedSubview(vc.view)
            })
            UIView.transition(with: popupContainerView, duration: 0.35, options: [.transitionFlipFromRight], animations: nil)
        }
    }
}
