![Logo](Vimeo%20player.png)

# Vimeo Player

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)

**VimeoPlayer** is a simple project for showing Vimeo videos that was developed with both **UIKit** and **SwiftUI**.

The main branch was created with UIKit, but you can check the SwiftUI version in the SwiftUI branch.

## Screenshots

| **Search videos**                                                                                                     | **Play video**                                                                                                        |
| --------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| ![App Screenshot](Screenshots/Simulator%20Screen%20Shot%20-%20iPhone%2014%20Pro%20-%202023-04-03%20at%2016.09.37.png) | ![App Screenshot](Screenshots/Simulator%20Screen%20Shot%20-%20iPhone%2014%20Pro%20-%202023-04-03%20at%2016.09.52.png) |
| **Support rotatin**                                                                                                   | **Support fullscreen**                                                                                                |
| ![App Screenshot](Screenshots/Simulator%20Screen%20Shot%20-%20iPhone%2014%20Pro%20-%202023-04-03%20at%2016.10.03.png) | ![App Screenshot](Screenshots/Simulator%20Screen%20Shot%20-%20iPhone%2014%20Pro%20-%202023-04-03%20at%2016.10.43.png) |

- [Features](#features)
  - [UIKit](#uikit)
  - [SwiftUI](#swiftui)
  - [Common](#common)
- [Installation](#installation)
  - [UIKit version](#cocopods)
  - [SwiftUI version](#swift-package-manager)
  - [Setup token](#swift-package-manager)
- [Authors](#authors)
- [Contributing](#contributing)
- [License](#license)

## Features

###### UIKit

- Support device rotation with the Xcode variation traits feature.
- Use Storyboard for the UIKit version.
- Create a custom player view with UIKit.
- Use Rx family pods like RxSwift, RxCoco, etc.
- Use Rxflow for navigation.
- Use Nuke for image loading.

### SwifUI

- Support device rotation.
- Use combine
- Create a custom player view for SwiftUI.

## Common

- Search Vimeo videos
- Show comments, likes, and play count.
- Use the MVVM architect.

## Installation

### UIKit

To run the UIKit version you have to install [CocoaPods](https://cocoapods.org) first. than run `pod install` in project folder.

### SwiftUI

The swiftIU version is totally independent and dons't need to install any dependency.

Just press run 😁



### Setup Token

To use this app, you have to create your public API key by following this link: [Vimeo developer](https://developer.vimeo.com/)

This app works well with a public token, which is **an “Unauthenticated”** token, but to get all features, you must check the “**Authenticated”** token, then check the **private**, **interact,** and **stats** options.

After that, put the token in `Constants.swift` in the **AppConstants** folder instead of `{Put your token here}`.

```swift
struct Constants{
    struct Vimeo{
        static let Vimeo_base_url = "https://api.vimeo.com/"
        static let Vimeo_video_config_url = "https://player.vimeo.com/video/{id}/config"
        
        /// You can create your own public api key from this link:https://developer.vimeo.com/
        static let public_token = "{Put your token here}"
    }
}
```





## Authors

- [@ali72](https://www.github.com/ali72)

## Contributing

Contributions are always welcome!

For contributing, please download the project and create a new branch and add your codes.

## License
