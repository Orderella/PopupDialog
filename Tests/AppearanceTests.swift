import UIKit
import XCTest
@testable import PopupDialog

class AppearanceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDefaultAppearance() {

        // Instantiate dialog
        let popup = PopupDialog(title: "Test Title", message: "Test Message")
        XCTAssertNotNil(popup, "Popup Dialog should be non-nil")

        // Get popup dialog view
        guard let view = popup.viewController.view as? PopupDialogDefaultView else {
            XCTFail("Could not instantiate Popup Dialog view")
            return
        }

        // Popup container defaults
        XCTAssertEqual(popup.popupContainerView.backgroundColor, UIColor.whiteColor())
        XCTAssertEqual(popup.popupContainerView.cornerRadius, 4)
        XCTAssertTrue(popup.popupContainerView.shadowEnabled)
        XCTAssertEqual(popup.popupContainerView.shadowColor, UIColor.blackColor())

        // Popup view defaults
        XCTAssertEqual(view.titleFont, UIFont.boldSystemFontOfSize(14))
        XCTAssertEqual(view.titleColor, UIColor(white: 0.4, alpha: 1))
        XCTAssertTrue (view.titleTextAlignment == .Center)
        XCTAssertEqual(view.messageFont, UIFont.systemFontOfSize(14))
        XCTAssertEqual(view.messageColor, UIColor(white: 0.6, alpha: 1))
        XCTAssertTrue (view.messageTextAlignment == .Center)

        // Button defaults
        let defaultButton = DefaultButton(title: "", action: nil)
        XCTAssertEqual(defaultButton.titleFont, UIFont.systemFontOfSize(14))
        XCTAssertEqual(defaultButton.titleColor!, UIColor(red: 0.25, green: 0.53, blue: 0.91, alpha: 1))
        XCTAssertEqual(defaultButton.buttonColor, UIColor.clearColor())
        XCTAssertEqual(defaultButton.separatorColor, UIColor(white: 0.9, alpha: 1))

        // Overlay view
        let overlay = PopupDialogOverlayView(frame: .zero)
        XCTAssertEqual(overlay.color, UIColor.blackColor())
        XCTAssertEqual(overlay.blurRadius, 8)
        XCTAssertTrue(overlay.blurEnabled)
        XCTAssertEqual(overlay.opacity, 0.7)
        XCTAssertFalse(overlay.liveBlur)
    }

    func testCustomAppearance() {

        // Customize view appearance
        let pv = PopupDialogDefaultView.appearance()
        pv.backgroundColor      = UIColor.blackColor()
        pv.titleFont            = UIFont(name: "HelveticaNeue", size: 14)!
        pv.titleColor           = UIColor.redColor()
        pv.titleTextAlignment   = .Left
        pv.messageFont          = UIFont(name: "HelveticaNeue", size: 16)!
        pv.messageColor         = UIColor.redColor()
        pv.messageTextAlignment = .Right

        let pcv = PopupDialogContainerView.appearance()
        pcv.cornerRadius        = 10
        pcv.shadowEnabled       = false
        pcv.shadowColor         = UIColor.greenColor()

        // Customize overlay appearance
        let ov = PopupDialogOverlayView.appearance()
        ov.color = UIColor.yellowColor()
        ov.blurRadius = 20
        ov.blurEnabled = false
        ov.liveBlur = true
        ov.opacity = 0.5

        // Customize default button appearance
        let db = DefaultButton.appearance()
        db.titleFont      = UIFont(name: "HelveticaNeue", size: 14)!
        db.titleColor     = UIColor.greenColor()
        db.buttonColor    = UIColor.darkGrayColor()
        db.separatorColor = UIColor.orangeColor()

        // Popup view customized appearance
        XCTAssertEqual(pv.backgroundColor, UIColor.blackColor())
        XCTAssertEqual(pv.titleFont, UIFont(name: "HelveticaNeue", size: 14)!)
        XCTAssertEqual(pv.titleColor, UIColor.redColor())
        XCTAssertTrue (pv.titleTextAlignment == .Left)
        XCTAssertEqual(pv.messageFont, UIFont(name: "HelveticaNeue", size: 16)!)
        XCTAssertEqual(pv.messageColor, UIColor.redColor())
        XCTAssertTrue (pv.messageTextAlignment == .Right)

        // Popup container view customized appearance
        XCTAssertEqual(pcv.cornerRadius, 10)
        XCTAssertFalse(pcv.shadowEnabled)
        XCTAssertEqual(pcv.shadowColor, UIColor.greenColor())

        // Overlay customized appearance
        XCTAssertEqual(ov.color, UIColor.yellowColor())
        XCTAssertEqual(ov.blurRadius, 20)
        XCTAssertFalse(ov.blurEnabled)
        XCTAssertEqual(ov.opacity, 0.5)
        XCTAssertTrue(ov.liveBlur)

        // Button customized appearance
        XCTAssertEqual(db.titleFont, UIFont(name: "HelveticaNeue", size: 14)!)
        XCTAssertEqual(db.titleColor!, UIColor.greenColor())
        XCTAssertEqual(db.buttonColor, UIColor.darkGrayColor())
        XCTAssertEqual(db.separatorColor, UIColor.orangeColor())
    }

}
