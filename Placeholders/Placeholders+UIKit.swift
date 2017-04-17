//
//  Placeholders+UIKit.swift
//  Placeholders
//
//  Created by Олег on 13.04.17.
//  Copyright © 2017 AnySuggestion. All rights reserved.
//

import UIKit

public protocol TextFieldPlaceholder {
    
    func set(on textField: UITextField)
    
}

extension String : TextFieldPlaceholder {
    
    public func set(on textField: UITextField) {
        textField.placeholder = self
    }
    
}

extension NSAttributedString : TextFieldPlaceholder {
    
    public func set(on textField: UITextField) {
        textField.attributedPlaceholder = self
    }
    
}

extension UITextField {
    
    var isTextEmpty: Bool {
        if let text = text {
            return text.isEmpty
        }
        return true
    }
    
    public struct PlaceholderChange<Placeholder : TextFieldPlaceholder> {
        
        private let _setNewPlaceholder: (Placeholder, UITextField) -> ()
        
        public func setNewPlaceholder(_ placeholder: Placeholder, on textField: UITextField) {
            guard textField.isTextEmpty else { return }
            _setNewPlaceholder(placeholder, textField)
        }
        
        public init(setNewPlaceholder: @escaping (Placeholder, UITextField) -> ()) {
            self._setNewPlaceholder = setNewPlaceholder
        }
        
    }
    
}

extension UITextField.PlaceholderChange {
    
    public static func caTransition(_ transition: @escaping () -> CATransition) -> UITextField.PlaceholderChange<Placeholder> {
        return UITextField.PlaceholderChange { (placeholder, textField) in
            let transition = transition()
            textField.subviews.first(where: { NSStringFromClass(type(of: $0)) == "UITextFieldLabel" })?.layer.add(transition, forKey: nil)
            placeholder.set(on: textField)
        }
    }
    
    public enum TransitionPushDirection {
        case fromBottom
        case fromLeft
        case fromRight
        case fromTop
        
        public var coreAnimationConstant: String {
            switch self {
            case .fromBottom:
                return kCATransitionFromBottom
            case .fromTop:
                return kCATransitionFromTop
            case .fromLeft:
                return kCATransitionFromLeft
            case .fromRight:
                return kCATransitionFromRight
            }
        }
    }
    
    public static func pushTransition(_ direction: TransitionPushDirection,
                            duration: TimeInterval = 0.35,
                            timingFunction: CAMediaTimingFunction = .init(name: kCAMediaTimingFunctionEaseInEaseOut)) -> UITextField.PlaceholderChange<Placeholder> {
        return .caTransition {
            let transition = CATransition()
            transition.duration = duration
            transition.timingFunction = timingFunction
            transition.type = kCATransitionPush
            transition.subtype = direction.coreAnimationConstant
            return transition
        }
    }
    
}

extension Placeholders where Element : TextFieldPlaceholder {
    
    public func start(interval: TimeInterval,
                      fireInitial: Bool = true,
                      textField: UITextField,
                      animation change: UITextField.PlaceholderChange<Element>) {
        self.start(interval: interval, fireInitial: fireInitial) { [weak textField, weak self] (placeholder) in
            if let textField = textField {
                change.setNewPlaceholder(placeholder, on: textField)
            } else {
                self?.timer?.invalidate()
            }
        }
    }
    
}
