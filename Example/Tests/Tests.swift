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
        guard let view = popup.view as? PopupDialogView else {
            XCTFail("Could not instantiate Popup Dialog view")
            return
        }

        XCTAssertEqual(view.titleLabel.text, "Test Title", "Popup Dialog title should be set correctly")
        XCTAssertEqual(view.messageLabel.text, "Test Message", "Popup Dialog message should be set correctly")
        XCTAssertNil(view.imageView.image, "Popup Dialog image should be nil")
    }

    func testImageDialogInstantiation() {

        // Create image
        let image = UIImage(named: "santa_cat", inBundle: NSBundle.mainBundle(), compatibleWithTraitCollection: nil)
        XCTAssertNotNil(image, "Image should not be nil")

        // Instantiate dialog with image
        let popup = PopupDialog(title: "", message: "", image: image)
        XCTAssertNotNil(popup, "Popup Dialog should be non-nil")

        // Get popup dialog view
        guard let view = popup.view as? PopupDialogView else {
            XCTFail("Could not instantiate Popup Dialog view")
            return
        }

        XCTAssertNotNil(view.imageView.image, "Popup dialog image should not be nil")
    }

    func testButtonAssignments() {

        // Instantiate dialog
        let popup = PopupDialog(title: "Test Title", message: "Test Message")
        XCTAssertNotNil(popup, "Popup Dialog should be non-nil")

        // Get popup dialog view
        guard let view = popup.view as? PopupDialogView else {
            XCTFail("Could not instantiate Popup Dialog view")
            return
        }

        // Create four buttons
        var buttons = [PopupDialogButton]()
        for index in 1...4 {
            let button = DefaultButton(title: "Test \(index)") { _ in }
            XCTAssertNotNil(button, "Button should be non-nil")
            XCTAssertEqual(button.titleForState(.Normal), "Test \(index)", "Button title should be set correctly")
            XCTAssertNotNil(button.buttonAction, "Button action should be non-nil")
            buttons.append(button)
        }

        // Add buttons to
        popup.addButtons(buttons)

        // Show popup dialog
        popup.beginAppearanceTransition(true, animated: false)

        XCTAssertEqual(view.buttonStackView.arrangedSubviews.count, 4, "Popup dialog should display four buttons")
    }

    func testButtonTaps() {

        let expectation = expectationWithDescription("Button action needs to be called")

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

        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
}
