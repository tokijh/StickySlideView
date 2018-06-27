# StickySlideView

[![Swift 4.1](https://img.shields.io/badge/swift-4.1-orange.svg?style=flat)](https://swift.org)
[![CI Status](http://img.shields.io/travis/tokijh/StickySlideView.svg?style=flat)](https://travis-ci.org/tokijh/StickySlideView)
[![Version](https://img.shields.io/cocoapods/v/StickySlideView.svg?style=flat)](http://cocoapods.org/pods/StickySlideView)
[![License](https://img.shields.io/cocoapods/l/StickySlideView.svg?style=flat)](http://cocoapods.org/pods/StickySlideView)
[![Platform](https://img.shields.io/cocoapods/p/StickySlideView.svg?style=flat)](http://cocoapods.org/pods/StickySlideView)

## Introduction
SlideView synchronized with ScrollView

![sample](https://github.com/tokijh/StickySlideView/blob/master/Docs/sample.gif)

## Noti
### v1.1
Now, you can use estimated height function</br>
It will calculate height dynamically through `containerView.contentSize`.

![estimatedSample](https://github.com/tokijh/StickySlideView/blob/master/Docs/estimatedSample.gif)

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation
StickySlideView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'StickySlideView'
```

## Usage
### In storyboard
You can connect scrollview by containerView like follow image
![sample](https://github.com/tokijh/StickySlideView/blob/master/Docs/storyboardsample.png)

### In code
```
import StickySlideView
```
You can create StickySlideView, like follow
```
StickySlideView(containerView: self.scrollView)
```
Also append this in view
```
view.addSubview(self.stickyView)
```

**Also welcome to PR whenever.**

## Author
* [tokijh](https://github.com/tokijh)

## License
StickySlideView is available under the MIT License See the [LICENSE](https://github.com/tokijh/StickySlideView/blob/master/LICENSE) file for more info.
