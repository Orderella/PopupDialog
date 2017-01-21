import XCTest

class UITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDefaultDialogWithImage() {
        XCTAssert(app.staticTexts["Tap the buttons!"].exists)
        
        app.buttons["Show Image Dialog"].tap()
        app.buttons["ADMIRE CAR"].tap()
        XCTAssert(app.staticTexts["What a beauty!"].exists)
        
        app.buttons["Show Image Dialog"].tap()
        app.buttons["BUY CAR"].tap()
        XCTAssert(app.staticTexts["Ah, maybe next time :)"].exists)
        
        app.buttons["Show Image Dialog"].tap()
        app.buttons["CANCEL"].tap()
        XCTAssert(app.staticTexts["You canceled the car dialog."].exists)
    }
    
    func testDefaultDialogWithoutImage() {
        XCTAssert(app.staticTexts["Tap the buttons!"].exists)
        
        app.buttons["Show Standard Dialog"].tap()
        app.buttons["OK"].tap()
        XCTAssert(app.staticTexts["You ok'd the default dialog"].exists)
        
        app.buttons["Show Standard Dialog"].tap()
        app.buttons["CANCEL"].tap()
        XCTAssert(app.staticTexts["You canceled the default dialog"].exists)
    }
    
    func testCustomDialog() {
        XCTAssert(app.staticTexts["Tap the buttons!"].exists)
        
        let showCustomDialogButton = app.buttons["Show Custom Dialog"]
        
        showCustomDialogButton.tap()
        app.buttons["CANCEL"].tap()
        XCTAssert(app.staticTexts["You canceled the rating dialog"].exists)
        
        showCustomDialogButton.tap()
        app.otherElements["Rating"].tap()
        app.buttons["RATE"].tap()
        XCTAssert(app.staticTexts["You rated 3.0 stars"].exists)
    }
    
}
