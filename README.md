# Placeholders

[![Swift][swift-badge]][swift-url]
[![Platform][platform-badge]][platform-url]

**Placeholders** gives you the ability to define multiple placeholders for `UITextField`, and also animate their change in the way you like. The result looks like that:

![Demo](Resources/Demo.gif)

You can read more about the library on [Medium][medium-article-url].

## Usage
#### 1. Define a `Placeholder` object in your view controller:

```swift
let placeholders = Placeholders(placeholders: ["First", "Second", "Third"])
```

If you want to loop placeholders (make the set infinite):

```swift
let placeholders = Placeholders(placeholders: ["First", "Second", "Third"], options: .infinite)
```

If you also want to show them in a random order:

```swift
let placeholders = Placeholders(placeholders: ["First", "Second", "Third"], options: [.infinite, .shuffle])
```

#### 2. In your `viewWillAppear` method, call `.start`:

```swift
placeholders.start(interval: 3.0,
                   fireInitial: true,
                   textField: textField,
                   animation: .pushTransition(.fromBottom))
```

That's it!

## Advanced
While being easy-to-use, **Placeholders** can be highly customized. At it's core, `Placeholders` object doesn't know anything about `UITextField`. You can easily use it for other purposes if you wish:

```swift
let placeholders = Placeholders(placeholders: ["A", "B", "C"], options: .infinite)
placeholders.start(interval: 2.0, fireInitial: true, action: { next in
    print(next)
})
```

Actually, the `UITextField` convenience is just a wrapper around this method.

But if you just want to make a custom `animation` as, for example, `.pushTransition`, you can extend `UITextField.PlaceholderChange`. Here is how you can implement your own custom fade animation:

```swift
extension UITextField.PlaceholderChange {
    
    static var fade: UITextField.PlaceholderChange<Placeholder> {
        return UITextField.PlaceholderChange { (placeholder, textField) in
            let transition = CATransition()
            transition.duration = 0.35
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            textField.subviews.first(where: { NSStringFromClass(type(of: $0)) == "UITextFieldLabel" })?.layer.add(transition, forKey: nil)
            placeholder.set(on: textField)
        }
    }
    
}
```

This generic `Placeholder` type and `placeholder.set(on: textField)` syntax exists in order to support `NSAttributedString` as a placeholder.

You can also use convenience `.caTransition` static function to make your life a bit easier:

```swift
extension UITextField.PlaceholderChange {
    
    static var fade: UITextField.PlaceholderChange<Placeholder> {
        return .caTransition {
            let transition = CATransition()
            transition.duration = 0.35
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            return transition
        }
    }
    
}
```

And now you can simply write:

```swift
placeholders.start(interval: 3.0,
                   fireInitial: true,
                   textField: textField,
                   animation: .fade)
```

Neat!

## Installation
**Placeholders** is available through [Carthage][carthage-url]. To install, just write into your Cartfile:

```ruby
github "dreymonde/Placeholders" ~> 0.1.0
```

We also encourage you to write your very own implementation that fits your needs best. Our source code is there to help.

[carthage-url]: https://github.com/Carthage/Carthage
[swift-badge]: https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat
[swift-url]: https://swift.org
[platform-badge]: https://img.shields.io/badge/Platform-iOS-lightgray.svg?style=flat
[platform-url]: https://developer.apple.com/swift/
[medium-article-url]: https://medium.com/anysuggestion/introducing-placeholders-1cc6927b097d
