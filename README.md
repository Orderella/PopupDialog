<img src="https://github.com/Orderella/PopupDialog/blob/master/Assets/PopupDialogLogo.png?raw=true" width="300">

<p>&nbsp;</p>

![Swift Version](https://img.shields.io/badge/Swift-5-orange.svg)
[![Version](https://img.shields.io/cocoapods/v/PopupDialog.svg?style=flat)](http://cocoapods.org/pods/PopupDialog)
[![License](https://img.shields.io/cocoapods/l/PopupDialog.svg?style=flat)](http://cocoapods.org/pods/PopupDialog)
[![Platform](https://img.shields.io/cocoapods/p/PopupDialog.svg?style=flat)](http://cocoapods.org/pods/PopupDialog)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status Master](https://travis-ci.org/Orderella/PopupDialog.svg?branch=master)](https://travis-ci.org/Orderella/PopupDialog)
[![Build Status Development](https://travis-ci.org/Orderella/PopupDialog.svg?branch=development)](https://travis-ci.org/Orderella/PopupDialog)
[![Reviewed by Hound](https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg)](https://houndci.com)

<p>&nbsp;</p>

# Introduction

Popup Dialog is a simple, customizable popup dialog written in Swift.

<img align="left" src="https://github.com/Orderella/PopupDialog/blob/master/Assets/PopupDialog01.gif?raw=true" width="300">
<img src="https://github.com/Orderella/PopupDialog/blob/master/Assets/PopupDialog02.gif?raw=true" width="300">
<img align="left" src="https://github.com/Orderella/PopupDialog/blob/master/Assets/PopupDialog03.gif?raw=true" width="300">
<img src="https://github.com/Orderella/PopupDialog/blob/master/Assets/PopupDialogDark01.png?raw=true" width="300">

## Features

- [x] Easy to use API with hardly any boilerplate code
- [x] Convenient default view with image, title, message
- [x] Supports custom view controllers
- [x] Slick transition animations
- [x] Fully themeable via appearance, including fonts, colors, corner radius, shadow, overlay color and blur, etc.
- [x] Can be dismissed via swipe and background tap
- [x] Objective-C compatible
- [x] Works on all screens and devices supporting iOS 10.0+

<p>&nbsp;</p>

# Installation

This version is Swift 5 compatible. For the Swift 4.2 version, please use [V1.0.0](https://github.com/Orderella/PopupDialog/releases/tag/1.0.0).

## CocoaPods

PopupDialog is available through [CocoaPods](http://cocoapods.org). Simply add the following to your Podfile:

```ruby
use_frameworks!

target '<Your Target Name>'
pod 'PopupDialog', '~> 1.1'
```

## Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. A minimum version of `0.17` is required.

To install, simply add the following lines to your Cartfile:

```ruby
github "Orderella/PopupDialog" ~> 1.1
```

## Manually

If you prefer not to use either of the above mentioned dependency managers, you can integrate PopupDialog into your project manually by adding the files contained in the [Classes](https://github.com/trungp/PopupDialog/tree/master/PopupDialog/Classes)
folder to your project. Moreover, you have to manually add the classes of [DynamicBlurView](https://github.com/KyoheiG3/DynamicBlurView/tree/master/DynamicBlurView) to your project.


<p>&nbsp;</p>

# Example

You can find this and more example projects in the repo. To run it, clone the repo, and run `pod install` from the Example directory first.

```swift
import PopupDialog

// Prepare the popup assets
let title = "THIS IS THE DIALOG TITLE"
let message = "This is the message section of the popup dialog default view"
let image = UIImage(named: "pexels-photo-103290")

// Create the dialog
let popup = PopupDialog(title: title, message: message, image: image)

// Create buttons
let buttonOne = CancelButton(title: "CANCEL") {
    print("You canceled the car dialog.")
}

// This button will not the dismiss the dialog
let buttonTwo = DefaultButton(title: "ADMIRE CAR", dismissOnTap: false) {
    print("What a beauty!")
}

let buttonThree = DefaultButton(title: "BUY CAR", height: 60) {
    print("Ah, maybe next time :)")
}

// Add buttons to dialog
// Alternatively, you can use popup.addButton(buttonOne)
// to add a single button
popup.addButtons([buttonOne, buttonTwo, buttonThree])

// Present dialog
self.present(popup, animated: true, completion: nil)
```

<p>&nbsp;</p>

# Usage

PopupDialog is a subclass of UIViewController and as such can be added to your view controller modally. You can initialize it either with the handy default view or a custom view controller.

## Default Dialog

```swift
public convenience init(
    title: String?,
    message: String?,
    image: UIImage? = nil,
    buttonAlignment: UILayoutConstraintAxis = .vertical,
    transitionStyle: PopupDialogTransitionStyle = .bounceUp,
    preferredWidth: CGFloat = 340,
    tapGestureDismissal: Bool = true,
    panGestureDismissal: Bool = true,
    hideStatusBar: Bool = false,
    completion: (() -> Void)? = nil) 
```

The default dialog initializer is a convenient way of creating a popup with image, title and message (see image one and three).

Bascially, all parameters are optional, although this makes no sense at all. You want to at least add a message and a single button, otherwise the dialog can't be dismissed, unless you do it manually.

If you provide an image it will be pinned to the top/left/right of the dialog. The ratio of the image will be used to set the height of the image view, so no distortion will occur.

## Custom View Controller

```swift
public init(
    viewController: UIViewController,
    buttonAlignment: UILayoutConstraintAxis = .vertical,
    transitionStyle: PopupDialogTransitionStyle = .bounceUp,
    preferredWidth: CGFloat = 340,
    tapGestureDismissal: Bool = true,
    panGestureDismissal: Bool = true,
    hideStatusBar: Bool = false,
    completion: (() -> Void)? = nil) 
```

You can pass your own view controller to PopupDialog (see image two). It is accessible via the `viewController` property of PopupDialog, which has to be casted to your view controllers class to access its properties. Make sure the custom view defines all constraints needed, so you don't run into any autolayout issues.

Buttons are added below the controllers view, however, these buttons are optional. If you decide to not add any buttons, you have to take care of dismissing the dialog manually. Being a subclass of view controller, this can be easily done via `dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?)`.

## Button Alignment

Buttons can be distributed either `.horizontal` or `.vertical`, with the latter being the default. Please note distributing buttons horizontally might not be a good idea if you have more than two buttons.

```swift
public enum UILayoutConstraintAxis : Int {
	case horizontal
	case vertical
}
```

## Transition Style

You can set a transition animation style with `.bounceUp` being the default. The following transition styles are available

```swift
public enum PopupDialogTransitionStyle: Int {
    case bounceUp
    case bounceDown
    case zoomIn
    case fadeIn
}
```

## Preferred Width

PopupDialog will always try to have a max width of 340 . On iPhones with smaller screens, like iPhone 5 SE, width would be 320.
340 is also the standard width for iPads. By setting preferredWidth you can override the max width of 340 for iPads only.

## Gesture Dismissal

Gesture dismissal allows your dialog being dismissed either by a background tap or by swiping the dialog down. By default, this is set to `true`. You can prevent this behavior by setting either `tapGestureDismissal` or `panGestureDismissal`  to `false` in the initializer.

## Hide Status Bar

PopupDialog can hide the status bar whenever it is displayed. Defaults to `false`. Make sure to add `UIViewControllerBasedStatusBarAppearance` to `Info.plist` and set it to `YES`.

## Completion
This completion handler is called when the dialog was dismissed. This is especially useful for catching a gesture dismissal.

<p>&nbsp;</p>

# Default Dialog Properties

If you are using the default dialog, you can change selected properties at runtime:

```swift
// Create the dialog
let popup = PopupDialog(title: title, message: message, image: image)

// Present dialog
self.present(popup, animated: true, completion: nil)

// Get the default view controller and cast it
// Unfortunately, casting is necessary to support Objective-C
let vc = popup.viewController as! PopupDialogDefaultViewController

// Set dialog properties
vc.image = UIImage(...)
vc.titleText = "..."
vc.messageText = "..."
vc.buttonAlignment = .horizontal
vc.transitionStyle = .bounceUp
```

<p>&nbsp;</p>

# Styling PopupDialog

Appearance is the preferred way of customizing the style of PopupDialog.
The idea of PopupDialog is to define a theme in a single place, without having to provide style settings with every single instantiation. This way, creating a PopupDialog requires only minimal code to be written and no "wrappers".

This makes even more sense, as popup dialogs and alerts are supposed to look consistent throughout the app, that is, maintain a single style.

## Dialog Default View Appearance Settings

If you are using the default popup view, the following appearance settings are available:

```swift
let dialogAppearance = PopupDialogDefaultView.appearance()

dialogAppearance.backgroundColor      = .white
dialogAppearance.titleFont            = .boldSystemFont(ofSize: 14)
dialogAppearance.titleColor           = UIColor(white: 0.4, alpha: 1)
dialogAppearance.titleTextAlignment   = .center
dialogAppearance.messageFont          = .systemFont(ofSize: 14)
dialogAppearance.messageColor         = UIColor(white: 0.6, alpha: 1)
dialogAppearance.messageTextAlignment = .center
```

## Dialog Container Appearance Settings

The container view contains the PopupDialogDefaultView or your custom view controller. the following appearance settings are available:

```swift
let containerAppearance = PopupDialogContainerView.appearance()

containerAppearance.backgroundColor = UIColor(red:0.23, green:0.23, blue:0.27, alpha:1.00)
containerAppearance.cornerRadius    = 2
containerAppearance.shadowEnabled   = true
containerAppearance.shadowColor     = .black
containerAppearance.shadowOpacity   = 0.6
containerAppearance.shadowRadius    = 20
containerAppearance.shadowOffset    = CGSize(width: 0, height: 8)
containerAppearance.shadowPath      = CGPath(...)
```

## Overlay View Appearance Settings

This refers to the view that is used as an overlay above the underlying view controller but below the popup dialog view. If that makes sense ;)

```swift
let overlayAppearance = PopupDialogOverlayView.appearance()

overlayAppearance.color           = .black
overlayAppearance.blurRadius      = 20
overlayAppearance.blurEnabled     = true
overlayAppearance.liveBlurEnabled = false
overlayAppearance.opacity         = 0.7
```

#### Note
Setting `liveBlurEnabled` to true, that is enabling realtime updates of the background view, results in a significantly higher CPU usage /power consumption and is therefore turned off by default. Choose wisely whether you need this feature or not ;)

## Button Appearance Settings

The standard button classes available are `DefaultButton`, `CancelButton` and `DestructiveButton`. All buttons feature the same appearance settings and can be styled seperately.

```swift
var buttonAppearance = DefaultButton.appearance()

// Default button
buttonAppearance.titleFont      = .systemFont(ofSize: 14)
buttonAppearance.titleColor     = UIColor(red: 0.25, green: 0.53, blue: 0.91, alpha: 1)
buttonAppearance.buttonColor    = .clear
buttonAppearance.separatorColor = UIColor(white: 0.9, alpha: 1)

// Below, only the differences are highlighted

// Cancel button
CancelButton.appearance().titleColor = .lightGray

// Destructive button
DestructiveButton.appearance().titleColor = .red
```

Moreover, you can create a custom button by subclassing `PopupDialogButton`. The following example creates a solid blue button, featuring a bold white title font. Separators are invisble.

```swift
public final class SolidBlueButton: PopupDialogButton {

    override public func setupView() {
        defaultFont           = .boldSystemFont(ofSize: 16)
        defaultTitleColor     = .white
        defaultButtonColor    = .blue
        defaultSeparatorColor = .clear
        super.setupView()
    }
}

```

These buttons can be customized with the appearance settings given above as well.

<p>&nbsp;</p>

## Dark mode example

The following is an example of a *Dark Mode* theme. You can find this in the Example project `AppDelegate`, just uncomment it to apply the custom appearance.

```swift
// Customize dialog appearance
let pv = PopupDialogDefaultView.appearance()
pv.titleFont    = UIFont(name: "HelveticaNeue-Light", size: 16)!
pv.titleColor   = .white
pv.messageFont  = UIFont(name: "HelveticaNeue", size: 14)!
pv.messageColor = UIColor(white: 0.8, alpha: 1)

// Customize the container view appearance
let pcv = PopupDialogContainerView.appearance()
pcv.backgroundColor = UIColor(red:0.23, green:0.23, blue:0.27, alpha:1.00)
pcv.cornerRadius    = 2
pcv.shadowEnabled   = true
pcv.shadowColor     = .black

// Customize overlay appearance
let ov = PopupDialogOverlayView.appearance()
ov.blurEnabled     = true
ov.blurRadius      = 30
ov.liveBlurEnabled = true
ov.opacity         = 0.7
ov.color           = .black

// Customize default button appearance
let db = DefaultButton.appearance()
db.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 14)!
db.titleColor     = .white
db.buttonColor    = UIColor(red:0.25, green:0.25, blue:0.29, alpha:1.00)
db.separatorColor = UIColor(red:0.20, green:0.20, blue:0.25, alpha:1.00)

// Customize cancel button appearance
let cb = CancelButton.appearance()
cb.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 14)!
cb.titleColor     = UIColor(white: 0.6, alpha: 1)
cb.buttonColor    = UIColor(red:0.25, green:0.25, blue:0.29, alpha:1.00)
cb.separatorColor = UIColor(red:0.20, green:0.20, blue:0.25, alpha:1.00)

```

<img src="https://github.com/Orderella/PopupDialog/blob/master/Assets/PopupDialogDark01.png?raw=true" width="260">
<img src="https://github.com/Orderella/PopupDialog/blob/master/Assets/PopupDialogDark02.png?raw=true" width="260">

I can see that there is room for more customization options. I might add more of them over time.

<p>&nbsp;</p>

# Screen sizes and rotation

Rotation and all screen sizes are supported. However, the dialog will never exceed a width of 340 points on iPhones. For iPads, you can set `preferredWidth` when initializing a new PopupDialog. However, landscape mode will not work well if the height of the dialog exceeds the width of the screen.

<p>&nbsp;</p>

# Working with text fields

If you are using text fields in your custom view controller, popup dialog makes sure that the dialog is positioned above the keybord whenever it appears. You can opt out of this behaviour by setting `keyboardShiftsView` to false on a PopupDialog.

# Testing

PopupDialog exposes a nice and handy method that lets you trigger a button tap programmatically:

```swift
public func tapButtonWithIndex(_ index: Int)
```

Other than that, PopupDialog unit tests are included in the root folder.

<p>&nbsp;</p>

# Objective-C

PopupDialog can be used in Objective-C projects as well.
Here is a basic example:

```objective-c
PopupDialog *popup = [[PopupDialog alloc] initWithTitle: @"Title"
                                                message: @"This is a message"
                                                  image: nil
                                        buttonAlignment: UILayoutConstraintAxisVertical
                                        transitionStyle: PopupDialogTransitionStyleBounceUp
                                         preferredWidth: 380
                                    tapGestureDismissal: NO
                                    panGestureDismissal: NO
                                          hideStatusBar: NO
                                             completion: nil];

DestructiveButton *delete = [[DestructiveButton alloc] initWithTitle: @"Delete"
                                                              height: 45
                                                        dismissOnTap: YES
                                                              action: nil];

CancelButton *cancel = [[CancelButton alloc] initWithTitle: @"Cancel"
                                                    height: 45
                                              dismissOnTap: YES
                                                    action: nil];

DefaultButton *ok = [[DefaultButton alloc] initWithTitle: @"OK"
                                                  height: 45
                                            dismissOnTap: YES
                                                  action: nil];

[dialog addButtons:@[delete, cancel, ok]];

[self presentViewController:popup animated:YES completion:nil];
```


<p>&nbsp;</p>


# Bonus

## Shake animation

If you happen to use PopupDialog to validate text input, for example, you can call the handy `shake()` method on PopupDialog.

<p>&nbsp;</p>

# Requirements

Minimum requirement is iOS 10.0. This dialog was written with Swift 5, for support of older versions please head over to releases.

<p>&nbsp;</p>

# Changelog
* **1.1.1** Updates dependencies to Swift 5
* **1.1.0** Swift 5 support
* **1.0.0** Pinned Swift version to 4.2<br>Dropped iOS 9 support as of moving to ios-snapshot-test-case
* **0.9.2** Fixes crash when presenting dialog while app is inactive
* **0.9.1** Fixes Carthage support
* **0.9.0** Swift 4.2 support
* **0.8.1** Added shadow appearance properties
* **0.8.0** Separated tap and pan gesture dismissal
* **0.7.1** Fixes Objective-C compatability<br>Improved Carthage handling
* **0.7.0** Removed FXBlurView while switching to DynamicBlurView
* **0.6.2** Added preferredWidth option for iPads
* **0.6.1** Added shake animation<br>Introduced hideStatusBar option
* **0.6.0** Swift 4 support<br>Dropped iOS8 compatibility
* **0.5.4** Fixed bug where blur view would reveal hidden layer<br>Improved view controller lifecycle handling<br>Scroll views can now be used with gesture dismissal
* **0.5.3** Fixed memory leak with custom view controllers<br>Added UI automation & snapshot tests
* **0.5.2** Fixed image scaling for default view
* **0.5.1** Introduced custom button height parameter<br>Reintroduced iOS8 compatibility
* **0.5.0** Swift 3 compatibility / removed iOS8
* **0.4.0** iOS 8 compatibility
* **0.3.3** Fixes buttons being added multiple times
* **0.3.2** Dialog repositioning when interacting with keyboard<br>Non dismissable buttons option<br>Additional completion handler when dialog is dismissed
* **0.3.1** Fixed Carthage issues
* **0.3.0** Objective-C compatibility
* **0.2.2** Turned off liveBlur by default to increase performance
* **0.2.1** Dismiss via background tap or swipe down transition
* **0.2.0** You can now pass custom view controllers to the dialog. This introduces breaking changes.
* **0.1.6** Defer button action until animation completes
* **0.1.5** Exposed dialog properties<br>(titleText, messageText, image, buttonAlignment, transitionStyle)
* **0.1.4** Pick transition animation style
* **0.1.3** Big screen support<br>Exposed basic shadow appearance
* **0.1.2** Exposed blur and overlay appearance
* **0.1.1** Added themeing example
* **0.1.0** Intitial version

<p>&nbsp;</p>

# Author

Martin Wildfeuer, mwfire@mwfire.de
for Orderella Ltd., [orderella.co.uk](http://orderella.co.uk)<br>
You might also want to follow us on Twitter, [@theMWFire](https://twitter.com/theMWFire) | [@Orderella](https://twitter.com/orderella)

# Thank you
Thanks to everyone who uses, enhances and improves this library, especially the contributors.
Moreover, thanks to KyoheiG3 for porting FXBlurView to [DynamicBlurView](https://github.com/KyoheiG3/DynamicBlurView).

<p>&nbsp;</p>

# License

PopupDialog is available under the MIT license. See the LICENSE file for more info.
