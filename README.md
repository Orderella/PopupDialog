# PopupDialog

[![Version](https://img.shields.io/cocoapods/v/PopupDialog.svg?style=flat)](http://cocoapods.org/pods/PopupDialog)
[![License](https://img.shields.io/cocoapods/l/PopupDialog.svg?style=flat)](http://cocoapods.org/pods/PopupDialog)
[![Platform](https://img.shields.io/cocoapods/p/PopupDialog.svg?style=flat)](http://cocoapods.org/pods/PopupDialog)

## Introduction

Popup Dialog is a simple, customizable alert view that is close to UIAlertController, written in Swift (2.2). You can add an image on top, though ;)

![PopupDialog example one](http://www.mwfire.de/orderella/github/PopupDialog01.gif "PopupDialog example one")
![PopupDialog example two](http://www.mwfire.de/orderella/github/PopupDialog02.gif "PopupDialog example two")

##Usage

PopupDialog is a subclass of UIViewController and as such can be added to your view controller modally.
The full initializer looks as follows:

```swift
public init(title: String?, message: String?, image: UIImage? = nil, buttonAlignment: UILayoutConstraintAxis = .Vertical)
```

Bascially, all parameters are optional, although this makes no sense at all. You want to at least add a message and a single button, otherwise the dialog can't be dismissed. I am planning on implementing dismiss by background tap or swipe in the future.

If you provide an image it will be pinned to the top/left/right of the dialog. The ratio of the image will be used to set the height of the image view, so no distortion will occur.

Buttons can be aligned either `.Horizontal` or `.Vertical`, with the latter being the default. Please note distributing buttons horizontally might not be a good idea if you have more than two buttons.


## Example

You can find this example project in the repo. To run it, clone the repo, and run `pod install` from the Example directory first.

```swift
let title = "This is a title"
let message = "This is a message"
let image = UIImage(named: "santa_cat")

// Create the dialog
let alert = PopupDialog(title: title, message: message, image: image)

// Create a button with cancel style
let buttonOne = CancelButton(title: "CANCEL CAT") {
    print("You canceled the cat. Whatever that means...")
}

// Create a button with default style
let buttonTwo = DefaultButton(title: "PLAY WITH CAT") {
    print("Phew, that was exhausting!")
}

// Create a button with destructive style
let buttonThree = DestructiveButton(title: "PET CAT") {
    print("The cat purrs happily :)")
}

// Add buttons to dialog
// Optionally, single buttons can be added
// with addButton(button: PopupDialogButton)
alert.addButtons([buttonOne, buttonTwo, buttonThree])

// Present dialog
self.presentViewController(alert, animated: true, completion: nil)

```

##Appearance

Many aspects of the popup dialog can be customized. Dialogs are supposed to have 
mostly the same layout throughout the app, therefore global appearance settings should make this easier. Find below the appearance settings and their default values.

```swift
// Popup Dialog View Appearance Settings
var dialogAppearance = PopupDialogView.appearance()

dialogAppearance.backgroundColor      = UIColor.whiteColor()
dialogAppearance.titleFont            = UIFont.boldSystemFontOfSize(14)
dialogAppearance.titleColor           = UIColor(white: 0.4, alpha: 1)
dialogAppearance.titleTextAlignment   = .Center
dialogAppearance.messageFont          = UIFont.systemFontOfSize(14)
dialogAppearance.messageColor         = UIColor(white: 0.6, alpha: 1)
dialogAppearance.messageTextAlignment = .Center
dialogAppearance.cornerRadius         = 4

// Popup Dialog Button Appearance Settings
// The standard button classes available are DefaultButton, CancelButton
// and DestructiveButton. On all buttons the same appearance can be set.
// Below, only the differences are highlighted
var buttonAppearance = DefaultButton.appearance()

// Default button
buttonAppearance.titleFont      = UIFont.systemFontOfSize(14)
buttonAppearance.titleColor     = UIColor(red: 0.25, green: 0.53, blue: 0.91, alpha: 1)
buttonAppearance.buttonColor    = UIColor.clearColor()
buttonAppearance.separatorColor = UIColor(white: 0.9, alpha: 1)

// Cancel button
CancelButton.appearance().titleColor = UIColor.lightGrayColor()

// Destructive button
DestructiveButton.appearance().titleColor = UIColor.redColor()
```

Moreover, you can create a custom button by subclassing `PopupDialogButton`. The following example creates a solid blue button, featuring a bold white title font. Separators are invisble.

```swift
public final class SolidBlueButton: PopupDialogButton {

    override public func setupView() {
        defaultFont           = UIFont.boldSystemFontOfSize(16)
        defaultTitleColor     = UIColor.whiteColor()
        defaultButtonColor    = UIColor.blueColor()
        defaultSeparatorColor = UIColor.clearColor()
        super.setupView()
    }
}

```

These buttons can be customized with the appearance settings given above as well.

I can see that there is room for more customization options. I might add more of them over time.

## Testing

PopupDialog exposes a nice but handy method that lets you trigger a button tap programmatically:

```swift
public func tapButtonWithIndex(index: Int)
```

Other than that, PopupDialog unit tests are included in the Example folder.

## Requirements

As this dialog is based on UIStackViews, a minimum Version of iOS 9.0 is required.
This dialog was written with Swift 2.2, 3.X compatability will be published on a seperate branch soon.

## Installation

PopupDialog is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PopupDialog', ~> '0.1.0'
```

## Author

Martin Wildfeuer, mwfire@mwfire.de
for Orderella Ltd., [orderella.co.uk](http://orderella.co.uk)

## Images in the sample project

The sample project features two images:<br>
Santa cat image courtesy of m_bartosch at FreeDigitalPhotos.net<br>
Cute kitten image courtesy of Tina Phillips at FreeDigitalPhotos.net<br>
Thanks a lot for providing these :)


## License

PopupDialog is available under the MIT license. See the LICENSE file for more info.
