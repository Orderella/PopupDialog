import UIKit
import XCTest
import Nimble
@testable import PopupDialog

class AppearanceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        resetAppearance()
    }

    func testDefaultAppearance() {

        // Instantiate dialog
        let popup = PopupDialog(title: "Test Title", message: "Test Message")
        expect(popup).toNot(beNil())

        // Get popup dialog view
        guard let view = popup.viewController.view as? PopupDialogDefaultView else {
            XCTFail("Could not instantiate Popup Dialog view")
            return
        }

        // Popup container defaults
        expect(popup.popupContainerView.backgroundColor) == UIColor.white
        expect(popup.popupContainerView.cornerRadius)    == 4
        expect(popup.popupContainerView.shadowColor)     == UIColor.black
        expect(popup.popupContainerView.shadowEnabled).to(beTrue())

        // Popup view defaults
        expect(view.titleFont)    == UIFont.boldSystemFont(ofSize: 14)
        expect(view.titleColor)   == UIColor(white: 0.4, alpha: 1)
        expect(view.messageFont)  == UIFont.systemFont(ofSize: 14)
        expect(view.messageColor) == UIColor(white: 0.6, alpha: 1)
        expect(view.titleTextAlignment == .center).to(beTrue())
        expect(view.messageTextAlignment == .center).to(beTrue())

        // Button defaults
        let defaultButton = DefaultButton(title: "", action: nil)
        expect(defaultButton.titleFont)      == UIFont.systemFont(ofSize: 14)
        expect(defaultButton.titleColor!)    == UIColor(red: 0.25, green: 0.53, blue: 0.91, alpha: 1)
        expect(defaultButton.buttonColor)    == UIColor.clear
        expect(defaultButton.separatorColor) == UIColor(white: 0.9, alpha: 1)
        
        let cancelButton = CancelButton(title: "", action: nil)
        expect(cancelButton.titleFont)      == UIFont.systemFont(ofSize: 14)
        expect(cancelButton.titleColor!)    == UIColor.lightGray
        expect(cancelButton.buttonColor)    == UIColor.clear
        expect(cancelButton.separatorColor) == UIColor(white: 0.9, alpha: 1)
        
        let destructiveButton = DestructiveButton(title: "", action: nil)
        expect(destructiveButton.titleFont)      == UIFont.systemFont(ofSize: 14)
        expect(destructiveButton.titleColor!)    == UIColor.red
        expect(destructiveButton.buttonColor)    == UIColor.clear
        expect(destructiveButton.separatorColor) == UIColor(white: 0.9, alpha: 1)
        
        // Overlay view
        let overlay = PopupDialogOverlayView(frame: .zero)
        expect(overlay.color)      == UIColor.black
        expect(overlay.blurRadius) == 8
        expect(overlay.blurEnabled).to(beTrue())
        expect(overlay.liveBlur).to(beFalse())
    }

    func testCustomAppearance() {

        // Customize view appearance
        let pv = PopupDialogDefaultView.appearance()
        pv.backgroundColor      = UIColor.black
        pv.titleFont            = UIFont(name: "HelveticaNeue", size: 14)!
        pv.titleColor           = UIColor.red
        pv.titleTextAlignment   = .left
        pv.messageFont          = UIFont(name: "HelveticaNeue", size: 16)!
        pv.messageColor         = UIColor.red
        pv.messageTextAlignment = .right

        let pcv = PopupDialogContainerView.appearance()
        pcv.cornerRadius        = 10
        pcv.shadowEnabled       = false
        pcv.shadowColor         = UIColor.green

        // Customize overlay appearance
        let ov = PopupDialogOverlayView.appearance()
        ov.color = UIColor.yellow
        ov.blurRadius = 20
        ov.blurEnabled = false
        ov.liveBlur = true
        ov.opacity = 0.5

        // Customize default button appearance
        let db = DefaultButton.appearance()
        db.titleFont      = UIFont(name: "HelveticaNeue", size: 14)!
        db.titleColor     = UIColor.green
        db.buttonColor    = UIColor.darkGray
        db.separatorColor = UIColor.orange

        // Popup view customized appearance
        expect(pv.backgroundColor) == UIColor.black
        expect(pv.titleFont)       == UIFont(name: "HelveticaNeue", size: 14)!
        expect(pv.titleColor)      == UIColor.red
        expect(pv.titleTextAlignment == .left).to(beTrue())
        expect(pv.messageFont)     == UIFont(name: "HelveticaNeue", size: 16)!
        expect(pv.messageColor)    == UIColor.red
        expect(pv.messageTextAlignment == .right).to(beTrue())

        // Popup container view customized appearance
        expect(pcv.cornerRadius) == 10
        expect(pcv.shadowColor)  == UIColor.green
        expect(pcv.shadowEnabled).to(beFalse())

        // Overlay customized appearance
        expect(ov.color)      == UIColor.yellow
        expect(ov.blurRadius) == 20
        expect(ov.opacity)    == 0.5
        expect(ov.blurEnabled).to(beFalse())
        expect(ov.liveBlur).to(beTrue())

        // Button customized appearance
        expect(db.titleFont)      == UIFont(name: "HelveticaNeue", size: 14)!
        expect(db.titleColor!)    == UIColor.green
        expect(db.buttonColor)    == UIColor.darkGray
        expect(db.separatorColor) == UIColor.orange
    }
    
    func resetAppearance() {
        // Customize view appearance
        let pv = PopupDialogDefaultView.appearance()
        pv.backgroundColor      = UIColor.white
        pv.titleFont            = UIFont.boldSystemFont(ofSize: 14)
        pv.titleColor           = UIColor(white: 0.4, alpha: 1)
        pv.titleTextAlignment   = .center
        pv.messageFont          = UIFont.systemFont(ofSize: 14)
        pv.messageColor         = UIColor(white: 0.6, alpha: 1)
        pv.messageTextAlignment = .center
        
        let pcv = PopupDialogContainerView.appearance()
        pcv.backgroundColor     = UIColor.white
        pcv.cornerRadius        = 4
        pcv.shadowEnabled       = true
        pcv.shadowColor         = UIColor.black
        
        // Customize overlay appearance
        let ov = PopupDialogOverlayView.appearance()
        ov.color       = UIColor.black
        ov.blurRadius  = 8
        ov.blurEnabled = true
        ov.liveBlur    = false
        ov.opacity     = 0.7
        
        // Customize default button appearance
        let db = DefaultButton.appearance()
        db.titleFont      = UIFont.systemFont(ofSize: 14)
        db.titleColor     = UIColor(red: 0.25, green: 0.53, blue: 0.91, alpha: 1)
        db.buttonColor    = UIColor.clear
        db.separatorColor = UIColor(white: 0.9, alpha: 1)
    }

}
