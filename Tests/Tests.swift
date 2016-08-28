import UIKit
import XCTest
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
        XCTAssertNotNil(popup, "Popup Dialog should be non-nil")

        // Get popup dialog view
        guard let vc = popup.viewController as? PopupDialogDefaultViewController else {
            XCTFail("Could not instantiate Popup Dialog view")
            return
        }

        XCTAssertEqual(vc.titleText, "Test Title", "Popup Dialog title should be set correctly")
        XCTAssertEqual(vc.messageText, "Test Message", "Popup Dialog message should be set correctly")
        XCTAssertNil(vc.image, "Popup Dialog image should be nil")
        XCTAssertTrue(popup.keyboardShiftsView, "Keyboard shifts view should be true by default")
    }

    func testImageDialogInstantiation() {

        // Create image
        let image = UIImage(named: "pexels-photo-103290", in: Bundle.main, compatibleWith: nil)
        XCTAssertNotNil(image, "Image should not be nil")

        // Instantiate dialog with image
        let popup = PopupDialog(title: "", message: "", image: image)
        XCTAssertNotNil(popup, "Popup Dialog should be non-nil")

        // Get popup dialog view
        guard let vc = popup.viewController as? PopupDialogDefaultViewController else {
            XCTFail("Could not instantiate Popup Dialog view")
            return
        }

        XCTAssertNotNil(vc.image, "Popup dialog image should not be nil")
    }

    func testDialogPropertyAccess() {

        // Instantiate dialog
        let popup = PopupDialog(title: "Test Title", message: "Test Message")
        XCTAssertNotNil(popup, "Popup Dialog should be non-nil")

        // Show popup dialog
        popup.beginAppearanceTransition(true, animated: false)

        // Create image
        let image = UIImage(named: "pexels-photo-103290", in: Bundle.main, compatibleWith: nil)
        XCTAssertNotNil(image, "Image should not be nil")

        // Change values after init
        popup.buttonAlignment = .vertical
        popup.transitionStyle = .fadeIn
        popup.keyboardShiftsView = false

        XCTAssertTrue(popup.buttonAlignment == .vertical)
        XCTAssertTrue(popup.transitionStyle == .fadeIn)
        XCTAssertFalse(popup.keyboardShiftsView)
    }

    func testDialogViewPropertyAccess() {

        // Instantiate dialog
        let popup = PopupDialog(title: "Test Title", message: "Test Message")
        XCTAssertNotNil(popup, "Popup Dialog should be non-nil")

        // Show popup dialog
        popup.beginAppearanceTransition(true, animated: false)

        // Get popup dialog view
         guard let vc = popup.viewController as? PopupDialogDefaultViewController else {
            XCTFail("Could not instantiate Popup Dialog view")
            return
        }

        // Create image
        let image = UIImage(named: "pexels-photo-103290", in: Bundle.main, compatibleWith: nil)
        XCTAssertNotNil(image, "Image should not be nil")

        vc.titleText = "New Test Title"
        vc.messageText = "New Test Message"
        vc.image = image

        XCTAssertEqual(vc.titleText, "New Test Title")
        XCTAssertEqual(vc.messageText, "New Test Message")
        XCTAssertNotNil(vc.image)
    }


    func testButtonAssignments() {

        // Instantiate dialog
        let popup = PopupDialog(title: "Test Title", message: "Test Message")
        XCTAssertNotNil(popup, "Popup Dialog should be non-nil")

        // Create four buttons
        var buttons = [PopupDialogButton]()
        for index in 1...4 {
            let button = DefaultButton(title: "Test \(index)") { _ in }
            XCTAssertNotNil(button, "Button should be non-nil")
            XCTAssertEqual(button.title(for: .normal), "Test \(index)", "Button title should be set correctly")
            XCTAssertNotNil(button.buttonAction, "Button action should be non-nil")
            buttons.append(button)
        }

        // Add buttons to
        popup.addButtons(buttons)

        // Show popup dialog
        popup.beginAppearanceTransition(true, animated: false)

        XCTAssertEqual(popup.popupContainerView.buttonStackView.arrangedSubviews.count, 4, "Popup dialog should display four buttons")
    }

    func testButtonTaps() {

        let expectation = self.expectation(description: "Button action needs to be called")

        // Instantiate dialog
        let popup = PopupDialog(title: "Test Title", message: "Test Message")
        XCTAssertNotNil(popup, "Popup Dialog should be non-nil")

        let button = DefaultButton(title: "Test") {
            XCTAssert(true, "Button action should be called")
            expectation.fulfill()
        }

        // Add button
        popup.addButton(button)

        // Show popup dialog
        popup.beginAppearanceTransition(true, animated: false)

        // Tap button with 0 index
        popup.tapButtonWithIndex(0)

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testCustomViewController() {

        // Create a custom view controller
        let vc = CustomViewController(nibName: nil, bundle: nil)

        // Init the popup with a custom view controller
        let popup = PopupDialog(viewController: vc)

        // Make sure the view controller is our custom view controller
        XCTAssertEqual(vc, popup.viewController)

        // Make sure the initial text is the expected one
        XCTAssertEqual(vc.testProperty, "I am a test")

        let popupVC = popup.viewController as! CustomViewController

        // Change the text
        popupVC.testProperty = "Changed"

        // Make sure the changed text is the expected one
        XCTAssertEqual(vc.testProperty, "Changed")
        XCTAssertEqual(popupVC.testProperty, "Changed")
    }
}
