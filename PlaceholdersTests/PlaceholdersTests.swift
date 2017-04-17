//
//  PlaceholdersTests.swift
//  PlaceholdersTests
//
//  Created by Олег on 13.04.17.
//  Copyright © 2017 AnySuggestion. All rights reserved.
//

import XCTest
@testable import Placeholders

extension UITextField.PlaceholderChange {
    
    static var fade_a: UITextField.PlaceholderChange<Placeholder> {
        return UITextField.PlaceholderChange { (placeholder, textField) in
            let transition = CATransition()
            transition.duration = 0.35
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            textField.subviews.first(where: { NSStringFromClass(type(of: $0)) == "UITextFieldLabel" })?.layer.add(transition, forKey: nil)
            placeholder.set(on: textField)
        }
    }
    
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

class PlaceholdersTests: XCTestCase {
    
    let placeholders = Placeholders(placeholders: ["First", "Second", "Third"], options: [.infinite, .shuffle])
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testREADME2() {
        let textField = UITextField()
        placeholders.start(interval: 3.0,
                           fireInitial: true,
                           textField: textField,
                           animation: .pushTransition(.fromBottom))
        placeholders.start(interval: 3.0,
                           fireInitial: true,
                           textField: textField,
                           animation: .fade)
    }
    
    func testREADME1() {
        let placeholders = Placeholders(placeholders: ["A", "B", "C"], options: .infinite)
        placeholders.start(interval: 2.0, fireInitial: true, action: { next in
            print(next)
        })
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
