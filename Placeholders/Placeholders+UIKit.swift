//
//  Placeholders+UIKit.swift
//  Placeholders
//
//  Created by Олег on 13.04.17.
//  Copyright © 2017 AnySuggestion. All rights reserved.
//

import UIKit

extension UITextField {
    
    var isTextEmpty: Bool {
        if let text = text {
            return text.isEmpty
        }
        return true
    }
    
    public struct PlaceholderChange {
        
        private let _setNewPlaceholder: (String, UITextField) -> ()
        
        public func setNewPlaceholder(_ placeholder: String, on textField: UITextField) {
            guard textField.isTextEmpty else { return }
            _setNewPlaceholder(placeholder, textField)
        }
        
        public init(setNewPlaceholder: @escaping (String, UITextField) -> ()) {
            self._setNewPlaceholder = setNewPlaceholder
        }
        
    }
    
}

extension UITextField.PlaceholderChange {
    
    public static func caTransition(_ transition: @escaping () -> CATransition) -> UITextField.PlaceholderChange {
        return UITextField.PlaceholderChange { (placeholder, textField) in
            let transition = transition()
            textField.subviews.first(where: { $0 is UILabel })?.layer.add(transition, forKey: nil)
            textField.placeholder = placeholder
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
    
    public static func push(_ direction: TransitionPushDirection,
                            duration: TimeInterval = 0.35,
                            timingFunction: CAMediaTimingFunction = .init(name: kCAMediaTimingFunctionEaseInEaseOut)) -> UITextField.PlaceholderChange {
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

extension Placeholders {
    
    public func start(interval: TimeInterval,
                      fireInitial: Bool = true,
                      textField: UITextField,
                      usingChange change: UITextField.PlaceholderChange) {
        self.start(interval: interval, fireInitial: fireInitial) { [weak textField, weak self] (placeholder) in
            if let textField = textField {
                change.setNewPlaceholder(placeholder, on: textField)
            } else {
                self?.timer?.invalidate()
            }
        }
    }
    
}
