import UIKit
import XCTest
import Nimble
@testable import PopupDialog

class Tests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStandardDialogInstantiation() {

        // Instantiate dialog
        let popup = PopupDialog(title: "Test Title", message: "Test Message")
        expect(popup).toNot(beNil())
        
        //XCTAssertNotNil(popup, "Popup Dialog should be non-nil")

        // Get popup dialog view
        guard let vc = popup.viewController as? PopupDialogDefaultViewController else {
            XCTFail("Could not instantiate Popup Dialog view")
            return
        }
        
        expect(vc.titleText)   == "Test Title"
        expect(vc.messageText) == "Test Message"
        expect(vc.image).to(beNil())
        expect(popup.keyboardShiftsView).to(beTrue())
    }

    func testImageDialogInstantiation() {

        // Create image
        let image = UIImage(named: "pexels-photo-103290", in: Bundle.main, compatibleWith: nil)
        expect(image).toNot(beNil())

        // Instantiate dialog with image
        let popup = PopupDialog(title: "", message: "", image: image)
        expect(popup).toNot(beNil())

        // Get popup dialog view
        guard let vc = popup.viewController as? PopupDialogDefaultViewController else {
            XCTFail("Could not instantiate Popup Dialog view")
            return
        }
        
        expect(vc.image).toNot(beNil())
    }

    func testDialogPropertyAccess() {

        // Instantiate dialog
        let popup = PopupDialog(title: "Test Title", message: "Test Message")
        expect(popup).toNot(beNil())

        // Show popup dialog
        popup.beginAppearanceTransition(true, animated: false)

        // Create image
        let image = UIImage(named: "pexels-photo-103290", in: Bundle.main, compatibleWith: nil)
        XCTAssertNotNil(image, "Image should not be nil")

        // Change values after init
        popup.buttonAlignment    = .vertical
        popup.transitionStyle    = .fadeIn
        popup.keyboardShiftsView = false

        expect(popup.buttonAlignment == .vertical).to(beTrue())
        expect(popup.transitionStyle == .fadeIn).to(beTrue())
        expect(popup.keyboardShiftsView).to(beFalse())
    }

    func testDialogViewPropertyAccess() {

        // Instantiate dialog
        let popup = PopupDialog(title: "Test Title", message: "Test Message")
        expect(popup).toNot(beNil())

        // Show popup dialog
        popup.beginAppearanceTransition(true, animated: false)

        // Get popup dialog view
         guard let vc = popup.viewController as? PopupDialogDefaultViewController else {
            XCTFail("Could not instantiate Popup Dialog view")
            return
        }

        // Create image
        let image = UIImage(named: "pexels-photo-103290", in: Bundle.main, compatibleWith: nil)
        expect(image).toNot(beNil())

        vc.titleText   = "New Test Title"
        vc.messageText = "New Test Message"
        vc.image       = image
        
        expect(vc.titleText)   == "New Test Title"
        expect(vc.messageText) == "New Test Message"
        expect(vc.image).toNot(beNil())
    }

    func testButtonAssignments() {

        // Instantiate dialog
        let popup = PopupDialog(title: "Test Title", message: "Test Message")
        expect(popup).toNot(beNil())

        // Create four buttons
        var buttons = [PopupDialogButton]()
        for index in 1...4 {
            let button = DefaultButton(title: "Test \(index)") { _ in }
            expect(button).toNot(beNil())
            expect(button.title(for: .normal)) == "Test \(index)"
            expect(button.buttonAction).toNot(beNil())
            buttons.append(button)
        }

        // Add buttons to dialog
        popup.addButtons(buttons)

        // Show popup dialog
        popup.beginAppearanceTransition(true, animated: false)
        
        if #available(iOS 9.0, *) {
            let buttonStackView = popup.popupContainerView.buttonStackView as! UIStackView
            expect(buttonStackView.arrangedSubviews.count) == 4
            expect(buttonStackView.arrangedSubviews) == buttons
        } else {
            let buttonStackView = popup.popupContainerView.buttonStackView as! TZStackView
            expect(buttonStackView.arrangedSubviews.count) == 4
            expect(buttonStackView.arrangedSubviews) == buttons
        }
    }

    func testButtonTaps() {

        // Button action triggered flag
        var buttonActionTriggered = false

        // Instantiate dialog
        let popup = PopupDialog(title: "Test Title", message: "Test Message")
        expect(popup).toNot(beNil())

        let button = DefaultButton(title: "Test", height: 70) {
            buttonActionTriggered = true
        }

        // Add button
        popup.addButton(button)

        // Show popup dialog
        popup.beginAppearanceTransition(true, animated: false)

        // Tap button with 0 index
        popup.tapButtonWithIndex(0)
        
        expect(buttonActionTriggered).toEventually(beTrue())
    }

    func testCustomViewController() {

        // Create a custom view controller
        let vc = CustomViewController(nibName: nil, bundle: nil)

        // Init the popup with a custom view controller
        let popup = PopupDialog(viewController: vc)

        // Make sure the view controller is our custom view controller
        expect(vc) == popup.viewController

        // Make sure the initial text is the expected one
        expect(vc.testProperty) == "I am a test"

        let popupVC = popup.viewController as! CustomViewController

        // Change the text
        popupVC.testProperty = "Changed"

        // Make sure the changed text is the expected one
        expect(vc.testProperty) == "Changed"
        expect(popupVC.testProperty) == "Changed"
    }
}
