![Logo](Vimeo%20player.png)

# Vimeo Player (SwiftUI version)

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)

**VimeoPlayer** is a simple project for showing Vimeo videos that was developed with both **UIKit** and **SwiftUI**.

This branch was developed using SwiftUI. check [UIKit version](https://github.com/SwiftLand/VimeoPlayer) in main branch.

## Screenshots

| **Search videos**                                                                                                     | **Play video**                                                                                                        |
| --------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| ![App Screenshot](Screenshots/Simulator%20Screen%20Shot%20-%20iPhone%2014%20Pro%20-%202023-04-03%20at%2016.09.37.png) | ![App Screenshot](Screenshots/Simulator%20Screen%20Shot%20-%20iPhone%2014%20Pro%20-%202023-04-03%20at%2016.09.52.png) |
| **Support rotatin**                                                                                                   | **Support fullscreen**                                                                                                |
| ![App Screenshot](Screenshots/Simulator%20Screen%20Shot%20-%20iPhone%2014%20Pro%20-%202023-04-03%20at%2016.10.03.png) | ![App Screenshot](Screenshots/Simulator%20Screen%20Shot%20-%20iPhone%2014%20Pro%20-%202023-04-03%20at%2016.10.43.png) |

- [Features](#features)
- [Installation](#installation)
- [Authors](#authors)
- [Contributing](#contributing)
- [License](#license)

## Features

### SwifUI

- Search Vimeo videos
- Show comments, likes, and play count.
- Use the MVVM architect.
- Support device rotation.
- Use combine
- Create a custom player view for SwiftUI.

## Installation

The swiftUI version doesn't require installing any dependencies.

To use this app, you have to create your public API key by following this link: [Vimeo developer](https://developer.vimeo.com/).

**Vimo player** works well with a public token, which is **an “Unauthenticated”** token, but to get all features, you must check the “**Authenticated”** token, then check the **private**, **interact,** and **stats** options.

After that, put the token in `Constants.swift` in the **AppConstants** folder instead of `{Put your token here}`.

```swift
struct Constants{
    struct Vimeo{
        static let base_url = "https://api.vimeo.com/"
        static let video_config_url = "https://player.vimeo.com/video/{id}/config"

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

**VimeoPlayer** is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
