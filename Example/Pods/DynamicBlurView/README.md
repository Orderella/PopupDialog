# DynamicBlurView

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/DynamicBlurView.svg?style=flat)](http://cocoadocs.org/docsets/DynamicBlurView)
[![License](https://img.shields.io/cocoapods/l/DynamicBlurView.svg?style=flat)](http://cocoadocs.org/docsets/DynamicBlurView)
[![Platform](https://img.shields.io/cocoapods/p/DynamicBlurView.svg?style=flat)](http://cocoadocs.org/docsets/DynamicBlurView)

DynamicBlurView is a dynamic and high performance UIView subclass for Blur.

#### [Appetize's Demo](https://appetize.io/app/9pvxr367tm0jj2bcy8zavxnqkg?device=iphone6&scale=75&orientation=portrait)

![home](https://user-images.githubusercontent.com/5707132/33749021-0342ea8c-dc0f-11e7-9260-af2d2e9c8d0c.gif)![home](https://user-images.githubusercontent.com/5707132/33749025-07595de0-dc0f-11e7-8814-fe757f437b69.png)


- Since using the CADisplayLink, it is a high performance.
- Can generate a plurality of BlurView.

## Requirements

- Swift 4.2
- iOS 8.0 or later
- tvOS 9.0 or later

## How to Install DynamicBlurView

#### CocoaPods

Add the following to your `Podfile`:

```Ruby
pod "DynamicBlurView"
```

#### Carthage

Add the following to your `Cartfile`:

```Ruby
github "KyoheiG3/DynamicBlurView"
```

## Usage

### Example

Blur the whole

```swift
let blurView = DynamicBlurView(frame: view.bounds)
blurView.blurRadius = 10
view.addSubview(blurView)
```

Animation

```swift
UIView.animateWithDuration(0.5) {
    blurView.blurRadius = 30
}
```

Ratio

```swift
blurView.blurRatio = 0.5
```

### Variable

```swift
var drawsAsynchronously: Bool
```

- When true, it captures displays image and blur it asynchronously. Try to set true if needs more performance.
- Asynchronous drawing is possibly crash when needs to process on main thread that drawing with animation for example.
- Default is false.

```Swift
var blurRadius: CGFloat
```

- Strength of the blur.

```Swift
var trackingMode: TrackingMode
```

- Mode for update frequency.
- `Common` is constantly updated.
- `Tracking` is only during scrolling update.
- `None` is not update.

```swift
var blendColor: UIColor?
```

- Blend in the blurred image.

```swift
var iterations: Int
```

- Number of times for blur.
- Default is 3.

```swift
var isDeepRendering: Bool
```

- If the view want to render beyond the layer, should be true.
- Default is false.

```swift
var blurRatio: CGFloat
```

- When none of tracking mode, it can change the radius of blur with the ratio. Should set from 0 to 1.
- Default is 1.

```swift
var quality: CaptureQuality
```

- Quality of captured image.
- Default is medium.

### Function

```swift
func refresh()
```

- Remove cache of blur image then get it again.

```swift
func remove()
```

- Remove cache of blur image.

```swift
func animate()
```

- Should use when needs to change layout with animation when is set none of tracking mode.

## Acknowledgements

- Inspired by [FXBlurView](https://github.com/nicklockwood/FXBlurView) in [nicklockwood](https://github.com/nicklockwood).

## Author

#### Kyohei Ito

- [GitHub](https://github.com/kyoheig3)
- [Twitter](https://twitter.com/kyoheig3)

Follow me 🎉

## LICENSE

Under the MIT license. See LICENSE file for details.
