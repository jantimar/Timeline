# Timeline

[![SPM Compatible](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)
![Platforms: iOS](https://img.shields.io/badge/platforms-iOS-brightgreen.svg?style=flat)
![Platform: tvOS](https://img.shields.io/badge/platforms-tvOS-brightgreen.svg?style=flat)
![Platform: macOS](https://img.shields.io/badge/platforms-macOS-brightgreen.svg?style=flat)

MVP concept in SwiftUI for show items in timeline (columns and rows), can be useful for show Time flow, TV program or explain Ant-Man Quantumania.

### TODO list
- [ ] Documentations
- [ ] Add tests

### Installation

As a Swift Package

`Timeline` is distributed via SPM. You can use it as a framework in your iOS project. In your `Package.swift` add a new package dependency:

```swift
.package(
    url: "https://github.com/jantimar/Timeline",
    from: "0.1.0"
)
```

### Usage

Import package with `import Tiemline` to enable initialize a view.

Prepare your data to implement `TimelineItem` protocol in 2 dimensions array `[[TimelineItem]]`

Initialize a`TimelineViewModel` with items. You can setup a `TimelineScale` or used a default a `day` scale.

```swift
let viewModel = TimelineViewModel(items: items) 

``` 
When your data is ready you can finally intialize a `TimelineView` with your model.
With a default init with `TimelineItemView` like a item view and without a grid or with a  `TimelineGridView`
```swift
TimelineView(viewModel: viewModel)
```
![default](/assets/sample2.png)

Or customize with init:
```swift
TimelineView(
    item: { item -> ItemView in /** initialize your custome item view **/ },
    grid: { start, end, width -> GridView? in /** initialize your custome grid view **/ }
)
```

## License and Credits

**Timeline** is released under the MIT license. See [LICENSE](/LICENSE) for details.

Created by [Jan Timar](https://github.com/jantimar).
