import UIKit

extension PopupDialog {
    public func animateTo(_ vc: UIViewController) {
        let stackView = popupContainerView.stackView
        let vcToRemove = childViewControllers[0]
        addChildViewController(vc)
        viewController = vc
        viewController.didMove(toParentViewController: self)
        vcToRemove.removeFromParentViewController()

        UIView.transition(
            with: popupContainerView.stackView,
            duration: 0.1,
            options: [.beginFromCurrentState],
            animations: {
                stackView.removeArrangedSubview(vcToRemove.view)
                stackView.addArrangedSubview(vc.view)
            }
        )
        UIView.transition(with: popupContainerView, duration: 0.35, options: [.transitionFlipFromRight], animations: nil)
    }
}
